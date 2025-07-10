variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
}

variable "reserved_ip" {
  description = "Reserved IP address"
  type        = string
}

variable "control_plane_ip" {
  description = "Control plane IP address"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "worker_ips" {
  description = "Worker node IP addresses"
  type        = list(string)
}

variable "reserved_ip_dependency" {
  description = "Dependency for reserved IP"
  type        = any
}

variable "worker_dependencies" {
  description = "Dependencies for worker nodes"
  type        = any
}