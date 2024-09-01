# -----------------------------------------------------------
# Security Group for ALB
# -----------------------------------------------------------

resource "aws_security_group" "alb_security_group" {

  name        = join("", [var.alb_name, "-alb"])
  description = "Allow inbound traffic on port 80 and 443"

  vpc_id = var.vpc_id

  tags = merge({
    "Name" = "${var.alb_name}-${local.vpc_suffix}-alb"
  }, var.tags)
}

data "aws_ip_ranges" "cloudfront" {
  services = ["CLOUDFRONT"]
}

resource "aws_security_group_rule" "alb_ingress_443" {
  description       = "Allow inbound traffic on port 80 and 443"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_security_group.id
#   cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks       = data.aws_ip_ranges.cloudfront.cidr_blocks

}

resource "aws_security_group_rule" "alb_ingress_80" {
  description       = "Allow inbound traffic on port 80 and 443"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_security_group.id
#   cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks       = data.aws_ip_ranges.cloudfront.cidr_blocks
}

resource "aws_security_group_rule" "alb_egress" {
  description       = "Allow outbound traffic on all ports"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb_security_group.id
#   cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks       = data.aws_ip_ranges.cloudfront.cidr_blocks

}

# # -----------------------------------------------------------
# # Security Group for CloudFront ALB
# # -----------------------------------------------------------
#
# resource "aws_security_group" "cf_alb_security_group" {
#   name        = join("", [var.alb_name, "-cf-alb"])
#   description = "Allow inbound traffic on port 80 and 443"
#   vpc_id      = var.vpc_id
#
# #   tags = var.custom_tags
#
#   tags = merge({
#     "Name" = "${var.alb_name}-${local.vpc_suffix}-cf-alb"
#   }, var.tags)
#
# }
#
# resource "aws_security_group_rule" "cf_alb_egress" {
#   description       = "Allow outbound traffic on all ports"
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.cf_alb_security_group.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# -----------------------------------------------------------
# Load Balancer
# -----------------------------------------------------------

resource "aws_s3_bucket" "alb_logs" {
  bucket = "labsecs-dummy-test-bucket2"
}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.alb_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket.alb_logs]

  bucket = aws_s3_bucket.alb_logs.id
  acl    = "private"
}
resource "aws_alb" "aws_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

    access_logs {
      bucket  = aws_s3_bucket.alb_logs.bucket
      prefix  = "alb_logs"
      enabled = true
    }

  tags = merge({
    "Name" = "${var.alb_name}-${local.vpc_suffix}-alb"
  }, var.tags)
}

# -----------------------------------------------------------
# Listener 443 - Default 403 response
# -----------------------------------------------------------

resource "aws_alb_listener" "alb_listener_443" {

  depends_on = [aws_acm_certificate_validation.acm_certificate_validation]

  load_balancer_arn = aws_alb.aws_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.acm_certificate.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{ \"message\": \"Unauthorised\" }"
      status_code  = "200" #"403"
    }
  }

  tags = merge({
    "Name" = "${var.alb_name}-${local.vpc_suffix}"
  }, var.tags)
}

# -----------------------------------------------------------
# Listener 80 - Default 403 response
# -----------------------------------------------------------

resource "aws_alb_listener" "alb_listener_80" {

  depends_on = [aws_acm_certificate_validation.acm_certificate_validation]

  load_balancer_arn = aws_alb.aws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{ \"message\": \"Unauthorised\" }"
      status_code  = "200" # "403"
    }
  }

  tags = merge({
    "Name" = "${var.alb_name}-${local.vpc_suffix}"
  }, var.tags)
}