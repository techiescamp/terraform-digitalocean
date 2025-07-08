# Kubernetes Lab Setup on DigitalOcean with Terraform

The provides a **modular Terraform configuration** to deploy a Kubernetes cluster on [DigitalOcean](https://www.digitalocean.com) for **learning and lab purposes**. The infrastructure is organized into reusable modules to enable easy experimentation and educational use.

---

## Architecture

The lab setup provisions:

- **Control Plane**: Single master node with a reserved IP address  
- **Worker Nodes**: 2 configurable worker nodes (adjustable)  
- **Networking**: VPC with private networking  
- **Security**: Basic firewall rules (permissive for lab use)   

---

## Project Structure

```bash
.
├── main.tf                 # Root configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values
├── README.md               # This file
├── scripts/                # Initialization scripts
│   ├── control-plane-init.sh
│   ├── worker-init.sh
│   └── install-calico.sh
└── modules/                # Terraform modules
    ├── networking/         # VPC, SSH keys, reserved IP
    ├── control-plane/      # Master node configuration
    ├── workers/            # Worker nodes configuration
    ├── firewall/           # Security rules
    └── k8s-setup/          # Kubernetes initialization
```
## Prerequisites 

**1. Tools Required**
- Terraform
- DigitalOcean CLI (doctl)
- Basic understanding of Kubernetes concepts and DigitalOcean

**2. DigitalOcean Setup**

- Create a DigitalOcean account (if you don’t already have one)
- Generate a Personal Access Token
  
Add your SSH key to DigitalOcean:
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
## Start with Lab Setup
**1. Clone and Configure**
```bash
git clone https://github.com/techiescamp/terraform-digitalocean.git
cd terraform-digitalocean
```
**2. Update `terraform.tfvars` with your values**
```bash
do_token             = "<your-token>" 
ssh_key_name         = "<your-ssh-key-name>"
ssh_private_key_path = "<your-SSH-private-key-local-path>"
region               = "blr1"              # Bangalore region
worker_count         = 2                   # Number of worker nodes
```
**3. Initialize and Deploy**
```bash
# Initialize Terraform
terraform init

# Preview the infrastructure plan
terraform plan

# Deploy the lab environment (10 minutes)
terraform apply --auto-approve
```
## Security Notice (Lab Configuration)
**⚠️ Lab Security Warning**: This configuration uses permissive security settings for ease of learning. Do not use these settings in production!

## Cleanup
To destroy the lab setup and avoid ongoing costs:
```bash
terraform destroy --auto-approve
```
## Cost Management
- Destroy the lab after each session
- Use smaller droplet sizes for learning
- Monitor your DigitalOcean billing dashboard
- Set up billing alerts in DigitalOcean
