variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "spaces_access_key_id" {
  description = "DigitalOcean Spaces Access Key ID"
  type        = string
  sensitive   = true
}

variable "spaces_secret_access_key" {
  description = "DigitalOcean Spaces Secret Access Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "blr1"
}

variable "space_name" {
  description = "Name of the DigitalOcean Space for Terraform backend"
  type        = string
}

variable "space_region" {
  description = "Region for the DigitalOcean Space"
  type        = string
  default     = "blr1"
}