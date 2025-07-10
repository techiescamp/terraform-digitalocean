output "worker_ids" {
  value = digitalocean_droplet.k8s_workers[*].id
}

output "worker_ips" {
  value = digitalocean_droplet.k8s_workers[*].ipv4_address
}