output "worker_ips" {
  value = module.workers.worker_ips
}

output "kubeconfig_command" {
  value = "scp root@${module.control_plane.control_plane_ip}:/etc/kubernetes/admin.conf ~/.kube/config"
}

output "control_plane_ip" {
  value = module.control_plane.control_plane_ip
}

output "reserved_ip" {
  value = module.networking.reserved_ip
}