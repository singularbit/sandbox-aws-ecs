# ---------------------------------------------------------------------------------------------------------------------
# ACM Certificate
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route53_record" "route53_record" {

  depends_on = [aws_cloudfront_distribution.cloudfront_distribution]

  zone_id = var.hosted_zone_id
  name    = "${var.alias}.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }

}