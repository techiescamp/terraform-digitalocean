terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "wait_for_k8s_ready" {
  depends_on = [var.reserved_ip_dependency]
  
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = var.reserved_ip
    port        = 22
    timeout     = "15m"
  }

  # Add a delay to ensure the droplet is fully ready
  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '=== Waiting for Kubernetes control plane to be ready ==='",
      "echo '[1/4] Waiting for cloud-init to complete...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done",
      "echo '[2/4] Checking cloud-init status...'",
      "cloud-init status --wait || (echo 'Cloud-init failed, checking logs:'; tail -50 /var/log/cloud-init-output.log; exit 1)",
      "echo '[3/4] Waiting for kubelet to be ready...'",
      "for i in {1..60}; do if systemctl is-active --quiet kubelet; then break; fi; sleep 10; done",
      "echo '[4/4] Waiting for Kubernetes API server...'",
      "export KUBECONFIG=/etc/kubernetes/admin.conf",
      "for i in {1..60}; do if kubectl get nodes &>/dev/null; then echo 'Kubernetes is ready!'; exit 0; fi; sleep 10; done",
      "echo 'Timeout waiting for Kubernetes'; exit 1"
    ]
  }
  
  provisioner "file" {
    source      = "scripts/install-calico.sh"
    destination = "/root/install-calico.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/install-calico.sh",
      "/root/install-calico.sh"
    ]
  }
}

resource "null_resource" "get_join_command" {
  depends_on = [null_resource.wait_for_k8s_ready]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = var.reserved_ip
    port        = 22
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "kubeadm token create --print-join-command > /tmp/join.sh",
      "chmod +x /tmp/join.sh"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.ssh_private_key_path} root@${var.reserved_ip}:/tmp/join.sh ./join.sh"
  }
}

resource "null_resource" "join_workers" {
  count = var.worker_count

  depends_on = [
    null_resource.get_join_command,
    var.worker_dependencies
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = var.worker_ips[count.index]
    timeout     = "10m"
  }

  # Add delay to ensure worker is ready
  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "file" {
    source      = "./join.sh"
    destination = "/tmp/join.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "echo '=== Joining worker node to cluster ==='",
      "cloud-init status --wait >/dev/null 2>&1",
      "chmod +x /tmp/join.sh",
      "/tmp/join.sh",
      "echo '=== Worker node successfully joined ==='",
      "sleep 30"
    ]
  }
}