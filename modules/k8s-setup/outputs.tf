output "k8s_setup_complete" {
  value = null_resource.join_workers[*].id
}