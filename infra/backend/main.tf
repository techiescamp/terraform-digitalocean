# DigitalOcean Space for Terraform backend
resource "digitalocean_spaces_bucket" "terraform_state" {
  name   = var.space_name
  region = var.space_region
  force_destroy = true
  versioning {
    enabled = true
  }
}

# Optional: Create a CDN endpoint for the Space
#resource "digitalocean_cdn" "terraform_state_cdn" {
#  origin = digitalocean_spaces_bucket.terraform_state.bucket_domain_name
#}
