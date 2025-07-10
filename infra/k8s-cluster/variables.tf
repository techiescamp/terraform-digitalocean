variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "SSH key name"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
  default     = "blr1"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "control_plane_size" {
  type    = string
  default = "s-2vcpu-4gb"
}

variable "worker_size" {
  type    = string
  default = "s-2vcpu-2gb"
}

variable "allowed_cidrs" {
  description = "List of allowed source/destination CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "tcp_ports" {
  description = "Port range for TCP traffic"
  type        = string
  default     = "1-65535"
}

variable "udp_ports" {
  description = "Port range for UDP traffic"
  type        = string
  default     = "1-65535"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "k8s-vpc"
}

variable "image" {
  description = "Image for the droplets"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "control_plane_hostname" {
  description = "Hostname for the control plane"
  type        = string
  default     = "controlplane"
}

variable "droplet_name_control_plane" {
  description = "Prefix for droplet names"
  type        = string
  default     = "k8s-controlplane"
}

variable "droplet_name_worker" {
  description = "Prefix for worker droplet names"
  type        = string
  default     = "k8s-worker"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = list(string)
  default     = ["k8s"]
}

variable "control_plane_tags" {
  description = "Tags for the control plane droplet"
  type        = list(string)
  default     = ["control-plane"]
}

variable "worker_tags" {
  description = "Tags for worker droplets"
  type        = list(string)
  default     = ["worker"]
}