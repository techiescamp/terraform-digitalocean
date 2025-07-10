variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "image" {
  description = "Image for the droplets"
  type        = string
}

variable "droplet_name_worker" {
  description = "Prefix for worker droplet names"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "worker_size" {
  description = "Size of worker droplets"
  type        = string
}

variable "ssh_key_id" {
  description = "SSH key ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = list(string)
}

variable "worker_tags" {
  description = "Tags for worker droplets"
  type        = list(string)
}