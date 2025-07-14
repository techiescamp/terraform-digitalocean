# DigitalOcean Space for Terraform backend
resource "digitalocean_spaces_bucket" "terraform_state" {
  name   = var.space_name
  region = var.space_region
  force_destroy = true
  versioning {
    enabled = true
  }
}

