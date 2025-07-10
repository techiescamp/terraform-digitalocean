



module "networking" {
  source = "../../modules/networking"

  ssh_key_name = var.ssh_key_name
  vpc_name     = var.vpc_name
  region       = var.region
  vpc_cidr     = var.vpc_cidr
}

module "control_plane" {
  source = "../../modules/control-plane"

  image                      = var.image
  droplet_name_control_plane = var.droplet_name_control_plane
  region                     = var.region
  control_plane_size         = var.control_plane_size
  ssh_key_id                 = module.networking.ssh_key_id
  vpc_id                     = module.networking.vpc_id
  control_plane_hostname     = var.control_plane_hostname
  reserved_ip                = module.networking.reserved_ip
  common_tags                = var.common_tags
  control_plane_tags         = var.control_plane_tags
}

module "workers" {
  source = "../../modules/workers"

  worker_count         = var.worker_count
  image                = var.image
  droplet_name_worker  = var.droplet_name_worker
  region               = var.region
  worker_size          = var.worker_size
  ssh_key_id           = module.networking.ssh_key_id
  vpc_id               = module.networking.vpc_id
  common_tags          = var.common_tags
  worker_tags          = var.worker_tags
}

module "firewall" {
  source = "../../modules/firewall"

  control_plane_id = module.control_plane.control_plane_id
  worker_ids       = module.workers.worker_ids
  allowed_cidrs    = var.allowed_cidrs
  tcp_ports        = var.tcp_ports
  udp_ports        = var.udp_ports
}

module "k8s_setup" {
  source = "../../modules/k8s-setup"

  ssh_private_key_path    = var.ssh_private_key_path
  reserved_ip             = module.networking.reserved_ip
  control_plane_ip        = module.control_plane.control_plane_ip
  worker_count            = var.worker_count
  worker_ips              = module.workers.worker_ips
  reserved_ip_dependency  = module.control_plane.control_plane_id
  worker_dependencies     = module.workers.worker_ids
  
  depends_on = [
    module.control_plane,
    module.workers,
    module.firewall
  ]
}