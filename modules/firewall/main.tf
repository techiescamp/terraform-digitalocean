terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_firewall" "k8s" {
  name = "k8s-firewall"

  droplet_ids = concat(
    [var.control_plane_id],
    var.worker_ids
  )

  inbound_rule {
    protocol         = "tcp"
    port_range       = var.tcp_ports
    source_addresses = var.allowed_cidrs
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = var.udp_ports
    source_addresses = var.allowed_cidrs
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = var.allowed_cidrs
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = var.tcp_ports
    destination_addresses = var.allowed_cidrs
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = var.udp_ports
    destination_addresses = var.allowed_cidrs
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = var.allowed_cidrs
  }
}