terraform {
  required_providers {
	digitalocean = {
	  source = "digitalocean/digitalocean"
	  version = "2.19.0"
	}
	dnsimple = {
	  source = "dnsimple/dnsimple"
	  version = "1.8.0"
	}
  }
}

variable "DO_TOKEN" {}

provider "digitalocean" {
  token = var.DO_TOKEN
}

data "digitalocean_ssh_key" "main_machine" {
  name = "ssh_destruidor"
}

resource "digitalocean_droplet" "web" {
  image   = "ubuntu-20-04-x64"
  name    = "alexandre-o-grande"
  region  = "fra1"
  size    = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.main_machine.id]
}

resource "digitalocean_domain" "default" {
  name = "franciscopontes.com"
  ip_address = digitalocean_droplet.web.ipv4_address
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "www"
  value  = digitalocean_droplet.web.ipv4_address
}
