terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_ssh_key" "k8s" {
  name = var.ssh_key_name
}

resource "digitalocean_vpc" "k8s" {
  name     = var.vpc_name
  region   = var.region
  ip_range = var.vpc_cidr
}

resource "digitalocean_reserved_ip" "k8s_control_plane" {
  region = var.region
}
