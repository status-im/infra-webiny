locals {
  mongo_ports = [ 27017 ]
}

module "webiny_vpc" {
  source = "github.com/status-im/infra-tf-aws-vpc"

  name  = "webiny"
  stage = terraform.workspace

  /* Firewall */
  open_tcp_ports = concat(local.mongo_ports, [ "22", "80", "443" ])
}

module "webiny_db" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "mongo"
  group  = "mongo"
  env    = "webiny"
  domain = var.domain

  /* Scaling */
  zone          = "${var.aws_zone}a"
  host_count    = 3
  instance_type = "t2.micro"
  root_vol_size = 30 /* GB */

  /* Network */
  vpc_id       = module.webiny_vpc.vpc_id
  subnet_id    = module.webiny_vpc.subnet_id
  secgroup_id  = module.webiny_vpc.secgroup_id

  /* Firewall */
  open_tcp_ports = local.mongo_ports

  /* Plumbing */
  keypair_name    = aws_key_pair.jakub.key_name
}
