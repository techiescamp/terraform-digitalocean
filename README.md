# Kubernetes Lab Setup on DigitalOcean with Terraform

This repository contains Terraform infrastructure as code (IaC) to deploy a Kubernetes learning lab on DigitalOcean using kubeadm, with CRI-O as the container runtime and Calico for networking. Perfect for hands-on learning, experimentation, and practicing Kubernetes concepts.

---

## Architecture

The lab setup provisions:

- **Control Plane**: Single control plane node with reserved IP (2 vCPU, 4GB RAM)
- **Worker Nodes**: 2 worker nodes by default (2 vCPU, 2GB RAM each)
- **Container Runtime**: CRI-O v1.33
- **Kubernetes Version**: v1.33.0
- **Network Plugin**: Calico v3.29.1
- **VPC**: Private networking with custom CIDR
- **Firewall**: Open firewall rules for lab experimentation (NOT for production) 
- **Spaces Object Storage** This for Terraform state file storage

## Prerequisites 

### **1. Tools Required**
- Terraform
- DigitalOcean CLI (doctl)
- SSH Key For accessing lab node
- Basic understanding of Kubernetes concepts and DigitalOcean

### **2. DigitalOcean Setup**

- Create a DigitalOcean account (if you don’t already have one)
- Open the DigitalOcean Console → Navigate API → Personal Access Tokens → Generate a new token with all permission
- copy the token 
### configuration doctl (DigitalOcean CLI)
```bash
doctl auth init

Please enter your access token: <Paste your token here>

# Verify Authentication
doctl account get

```
  
### Add your SSH key to DigitalOcean:
```bash
doctl compute ssh-key create "<key_name>" --public-key "$(cat ~/.ssh/id_rsa.pub)"
# verify the ssh key
doctl compute ssh-key list
```
**SSH Key Setup**
(If you don’t already have an SSH key):
```bash
ssh-keygen -t rsa -b 4096 
```
### Setup Environment Variables
Open the DigitalOcean Console → Navigate to Spaces (Object Storage) → Create an Access Key with Full Access → Click 'Create'.
copy access key  and secret key 
```bash
export AWS_ACCESS_KEY_ID="<your-spaces_access_key_id>"
export AWS_SECRET_ACCESS_KEY="<your-spaces_secret_access_key>"
```

## Start with Lab Setup
**1. Clone and Configure**
```bash
git clone https://github.com/techiescamp/terraform-digitalocean.git
cd terraform-digitalocean
```
**2. Update `vars/dev/backend.tfvars` `vars/dev/k8s-cluster.tfvars` `infra/k8s-cluster/backend.tf` with your values**
```bash
do_token             = "<your-token>" 
ssh_key_name         = "<your-ssh-key-name>"
ssh_private_key_path = "<your-SSH-private-key-local-path>"
region               = "blr1"              # Bangalore region
worker_count         = 2                   # Number of worker nodes
```
**3. Initialize and Deploy backend(Spaces Object Storage)**
```bash
cd  infra/backend/

# Initialize Terraform
terraform init

# Preview the infrastructure plan
terraform plan -var-file="../../vars/dev/backend.tfvars"

# Deploy the Spaces Object Storage 
terraform apply --auto-approve -var-file="../../vars/dev/backend.tfvars"
```

**4. Initialize and Deploy k8s cluster lab setup**
```bash
cd  ../k8s-cluster/  #OR  cd infra/k8s-cluster/

# Initialize Terraform
terraform init

# Preview the infrastructure plan
terraform plan -var-file="../../vars/dev/k8s-cluster.tfvars"

# Deploy the Spaces Object Storage 
terraform apply --auto-approve -var-file="../../vars/dev/k8s-cluster.tfvars"
```


## Security Notice (Lab Configuration)
**⚠️ Lab Security Warning**: This configuration uses permissive security settings for ease of learning. Do not use these settings in production!

## Cleanup
To destroy the lab setup and avoid ongoing costs:
```bash
terraform destroy --auto-approve -var-file="../../vars/dev/k8s-cluster.tfvars"
terraform destroy --auto-approve -var-file="../../vars/dev/backend.tfvars"
#delete SSH key 
doctl compute ssh-key delete <id>

```
## Cost Management
- Destroy the lab after each session
- Use smaller droplet sizes for learning
- Monitor your DigitalOcean billing dashboard
- Set up billing alerts in DigitalOcean
