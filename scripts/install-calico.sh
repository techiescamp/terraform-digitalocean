#!/bin/bash

set -e

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml 

sleep 30

curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O 

sleep 30 

# Step 3: Get cluster CIDR
echo "Step 3: Getting cluster CIDR..."
CLUSTER_CIDR=$(kubectl -n kube-system get pod -l component=kube-controller-manager -o jsonpath="{.items[*].spec.containers[*].command}" | grep -oP '(?<=--cluster-cidr=)[0-9./]+' | head -1)
if [ -z "$CLUSTER_CIDR" ]; then
    CLUSTER_CIDR="10.244.0.0/16"
    echo "Using default CIDR: $CLUSTER_CIDR"
else
    echo "Detected CIDR: $CLUSTER_CIDR"
fi

# Step 4: Update custom resource with correct CIDR
echo "Step 4: Updating custom resource with CIDR $CLUSTER_CIDR..."
sed -i "s|cidr: 192.168.0.0/16|cidr: $CLUSTER_CIDR|g" custom-resources.yaml
echo "Custom resource updated"

kubectl apply -f /root/custom-resources.yaml

