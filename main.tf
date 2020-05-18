/* DERIVED --------------------------------------*/

provider "aws" {
  version    = "~> 2.0"
  region     = var.aws_zone
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
