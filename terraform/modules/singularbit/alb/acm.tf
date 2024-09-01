resource "aws_acm_certificate" "acm_certificate" {

  domain_name       = "${var.project_name}.${var.hosted_zone_name}"
#   domain_name       = aws_alb.aws_alb.dns_name # NOTE: We can not generate a certificate for ...elb.amazonaws.com
  validation_method = "DNS"

  subject_alternative_names = []

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    "Name" = "${var.alb_name}-${local.vpc_suffix}"
  }, var.tags)
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}
