/* DERIVED --------------------------------------*/

provider "aws" {
  version    = "~> 2.0"
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "cloudflare" {
  email      = var.cloudflare_email
  api_key    = var.cloudflare_token
  account_id = var.cloudflare_account
}

/* DATA -----------------------------------------*/

terraform {
  backend "consul" {
    address   = "https://consul.statusim.net:8400"
    /* Lock to avoid syncing issues */
    lock      = true
    /* KV store has a limit of 512KB */
    gzip      = true
    /* WARNING This needs to be changed for every repo. */
    path      = "terraform/webiny/"
    ca_file   = "ansible/files/consul-ca.crt"
    cert_file = "ansible/files/consul-client.crt"
    key_file  = "ansible/files/consul-client.key"
  }
}

/* ACCESS KEY ------------------------------------------------------*/

resource "aws_key_pair" "jakub" {
  key_name   = "jakubgs"
  public_key = file("files/jakub@status.im.rsa")
}

/* CF Zones ------------------------------------*/

/* CloudFlare Zone IDs required for records */
data "cloudflare_zones" "active" {
  filter { status = "active" }
}

/* For easier access to zone ID by domain name */
locals {
  zones = {
    for zone in data.cloudflare_zones.active.zones:
      zone.name => zone.id
  }
}
