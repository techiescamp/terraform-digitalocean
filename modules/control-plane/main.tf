terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "k8s_control_plane" {
  image    = var.image
  name     = var.droplet_name_control_plane
  region   = var.region
  size     = var.control_plane_size
  ssh_keys = [var.ssh_key_id]
  vpc_uuid = var.vpc_id

  user_data = templatefile("${path.root}/scripts/control-plane-init.sh", {
    hostname    = var.control_plane_hostname
    reserved_ip = var.reserved_ip
  })
  tags = concat(var.common_tags, var.control_plane_tags)
}

resource "digitalocean_reserved_ip_assignment" "k8s_control_plane" {
  ip_address = var.reserved_ip
  droplet_id = digitalocean_droplet.k8s_control_plane.id
  
  depends_on = [digitalocean_droplet.k8s_control_plane]
}