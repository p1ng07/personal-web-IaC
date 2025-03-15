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
variable "DNSIMPLE_TOKEN" {}
variable "DNSIMPLE_ACCOUNT" {}

provider "digitalocean" {
  token = var.DO_TOKEN
}

resource "digitalocean_droplet" "web" {
  image   = "ubuntu-20-04-x64"
  name    = "alexandre-o-grande"
  region  = "fra1"
  size    = "s-1vcpu-1gb"
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
