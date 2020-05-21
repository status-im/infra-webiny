/* Configure managing domain with Route53 Hosted Zone */
resource "aws_route53_zone" "webiny" {
  name    = "get.status.im"
  comment = "Domain for Webiny hosts."
}

resource "cloudflare_record" "webiny" {
  zone_id    = local.zones["status.im"]
  name       = "get"
  type       = "NS"
  value      = aws_route53_zone.webiny.name_servers[count.index]
  #count     = length(aws_route53_zone.webiny.name_servers)
  count      = 4 /* Terraform is trash and can't do this dynamically */
  proxied    = false
  depends_on = [ aws_route53_zone.webiny ]
}
