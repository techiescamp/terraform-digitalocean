variable "control_plane_id" {
  description = "Control plane droplet ID"
  type        = string
}

variable "worker_ids" {
  description = "Worker droplet IDs"
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "List of allowed source/destination CIDRs"
  type        = list(string)
}

variable "tcp_ports" {
  description = "Port range for TCP traffic"
  type        = string
}

variable "udp_ports" {
  description = "Port range for UDP traffic"
  type        = string
}