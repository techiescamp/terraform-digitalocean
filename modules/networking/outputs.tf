output "ssh_key_id" {
  value = data.digitalocean_ssh_key.k8s.id
}

output "vpc_id" {
  value = digitalocean_vpc.k8s.id
}

output "reserved_ip" {
  value = digitalocean_reserved_ip.k8s_control_plane.ip_address
}

output "reserved_ip_id" {
  value = digitalocean_reserved_ip.k8s_control_plane.id
}