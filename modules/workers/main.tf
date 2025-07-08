terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "k8s_workers" {
  count    = var.worker_count
  image    = var.image
  name     = "${var.droplet_name_worker}-${count.index + 1}"
  region   = var.region
  size     = var.worker_size
  ssh_keys = [var.ssh_key_id]
  vpc_uuid = var.vpc_id

  user_data = templatefile("${path.root}/scripts/worker-init.sh", {
    hostname = format("node%02d", count.index + 1)
  })

  tags = concat(var.common_tags, var.worker_tags)
}