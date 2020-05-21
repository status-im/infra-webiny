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

resource "aws_route53_record" "webiny_db" {
  zone_id = aws_route53_zone.webiny.zone_id
  name    = "mongo-0${count.index+1}.db"
  type    = "A"
  ttl     = 30
  records = [ module.webiny_db.public_ips[count.index] ]
  count   = length(module.webiny_db.public_ips)
}

/* These allow for use of db.get.status.im in MongoDB URI */
resource "aws_route53_record" "webiny_db_srv" {
  zone_id = aws_route53_zone.webiny.zone_id
  name    = "_mongodb._tcp.db"
  type    = "SRV"
  ttl     = 30
  /* Order: priority weight port target */
  records = [
    for fqdn in aws_route53_record.webiny_db.*.fqdn:
      "0 10 27017 ${fqdn}"
  ]
}

resource "aws_route53_record" "webiny_db_txt" {
  zone_id = aws_route53_zone.webiny.zone_id
  name    = "db"
  type    = "TXT"
  ttl     = 30
  records = ["replicaSet=webiny"]
}
