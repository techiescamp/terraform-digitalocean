#!/bin/bash
set -e

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/k8s-control-plane-init.log
}

log " Starting Kubernetes control plane initialization..."

# Replace this with your hostname variable, if used in Terraform
hostnamectl set-hostname controlplane
echo "127.0.0.1 controlplane" >> /etc/hosts
log "Hostname set to controlplane"

# Versions
KUBERNETES_VERSION=v1.33
KUBERNETES_INSTALL_VERSION=1.33.2-1.1
CRIO_VERSION=v1.33

# Disable swap
swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab -

# Kernel modules and sysctl
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Dependencies
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gpg software-properties-common jq

# Install CRI-O
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

apt-get update -y
apt-get install -y cri-o
systemctl daemon-reload
systemctl enable crio --now
log "CRI-O installed and running"

# Install Kubernetes components
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet=$KUBERNETES_INSTALL_VERSION kubeadm=$KUBERNETES_INSTALL_VERSION kubectl=$KUBERNETES_INSTALL_VERSION
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet

# IP setup
PRIVATE_IP=$(hostname -I | awk '{print $3}')
RESERVED_IP="${reserved_ip}"

# kubeadm config
cat <<EOF > /root/kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "$PRIVATE_IP"
  bindPort: 6443
nodeRegistration:
  name: "controlplane"

---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: "v1.33.0"
controlPlaneEndpoint: "$RESERVED_IP:6443"
apiServer:
  extraArgs:
    - name: "enable-admission-plugins"
      value: "NodeRestriction"
    - name: "audit-log-path"
      value: "/var/log/kubernetes/audit.log"
controllerManager:
  extraArgs:
    - name: "node-cidr-mask-size"
      value: "24"
scheduler:
  extraArgs:
    - name: "leader-elect"
      value: "true"
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
  dnsDomain: "cluster.local"

---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: "systemd"
syncFrequency: "1m"

---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
conntrack:
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: "1h"
  tcpEstablishedTimeout: "24h"
EOF

log "Running kubeadm init..."
kubeadm init --config=/root/kubeadm-config.yaml

# kubectl setup
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

# Wait for API server
for i in {1..30}; do
  if kubectl get nodes &>/dev/null; then
    log "API server is ready!"
    break
  fi
  log "Waiting for API server... ($i/30)"
  sleep 10
done





