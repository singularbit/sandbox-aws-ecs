data "aws_route53_zone" "route53_zone" {
#  name         = var.route53_zone_name
  name         = var.domain
  private_zone = false
}