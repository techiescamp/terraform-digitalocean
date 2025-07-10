output "space_name" {
  description = "Name of the created DigitalOcean Space"
  value       = digitalocean_spaces_bucket.terraform_state.name
}

output "space_endpoint" {
  description = "Endpoint URL of the DigitalOcean Space"
  value       = digitalocean_spaces_bucket.terraform_state.endpoint
}

output "space_region" {
  description = "Region of the DigitalOcean Space"
  value       = digitalocean_spaces_bucket.terraform_state.region
}
