variable "image" {
  description = "Image for the droplets"
  type        = string
}

variable "droplet_name_control_plane" {
  description = "Name for control plane droplet"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "control_plane_size" {
  description = "Size of control plane droplet"
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

variable "control_plane_hostname" {
  description = "Hostname for the control plane"
  type        = string
}

variable "reserved_ip" {
  description = "Reserved IP address"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = list(string)
}

variable "control_plane_tags" {
  description = "Tags for the control plane droplet"
  type        = list(string)
}