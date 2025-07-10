output "worker_ips" {
  value = module.workers.worker_ips
}

output "control_plane_ip" {
  value = module.control_plane.control_plane_ip
}

output "reserved_ip" {
  value = module.networking.reserved_ip
}