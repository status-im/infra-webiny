locals {
  mongo_ports = [ 27017 ]
}

module "webiny_vpc" {
  source = "github.com/status-im/infra-tf-aws-vpc"

  name  = "webiny"
  stage = terraform.workspace
  zones = [ "${var.aws_region}a" ]

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
  host_count    = 3
  zone          = "${var.aws_region}a"
  instance_type = "t2.micro"
  root_vol_size = 30 /* GB */

  /* Network */
  vpc_id      = module.webiny_vpc.vpc.id
  secgroup_id = module.webiny_vpc.secgroup.id
  subnet_id   = module.webiny_vpc.subnets[0].id

  /* Firewall */
  open_tcp_ports = local.mongo_ports

  /* Plumbing */
  keypair_name    = aws_key_pair.jakub.key_name
}
