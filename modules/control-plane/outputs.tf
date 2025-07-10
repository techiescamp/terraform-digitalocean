output "control_plane_id" {
  value = digitalocean_droplet.k8s_control_plane.id
}

output "control_plane_ip" {
  value = digitalocean_droplet.k8s_control_plane.ipv4_address
}