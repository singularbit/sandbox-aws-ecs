# ---------------------------------------------------------------------------------------------------------------------
# ACM CERTIFICATE FOR CDN
# ---------------------------------------------------------------------------------------------------------------------
module "acm_certificate_4_cdn" {

  source = "./modules/singularbit/acm"

  providers = {
    aws = aws.us
  }

  # ACM Certificate
  subdomain = var.project_name
  domain    = data.aws_route53_zone.route53_zone.name

  custom_tags = merge({
    "Name" = "${var.project_name}-${var.branch_name}"
  }, local.custom_tags)

}

# # ---------------------------------------------------------------------------------------------------------------------
# # S3 FOR CLOUDFRONT LOGS
# # ---------------------------------------------------------------------------------------------------------------------
# module "s3_4_cdn_logs" {
#   source = "../modules/singularbit/s3"
#
#   # S3 Bucket
#   bucket_name = "${var.project_name}-${var.branch_name}-cdn-logs-${local.acc_4_chars}"
#
#   # S3 Bucket Server Side Encryption Configuration
#   use_bucket_server_side_encryption_configuration = false
#   encryption_algorithm = "" #"aws:kms"
#
#   # S3 Bucket Ownership Controls
#   set_bucket_ownership_controls = true
#   object_ownership =  "BucketOwnerPreferred" # "BucketOwnerPreferred" #"ObjectWriter" "BucketOwnerEnforced"
#
#   # S3 Bucket ACL
#   set_bucket_acl_private = true
#   s3_acl = "log-delivery-write"
#
#   # S3 Bucket Versioning - Default is Suspended
#   set_bucket_versioning_enabled = false
#   versioning_status = "Disabled"
#
#   # S3 Bucket Public Access Block
#   set_bucket_policy_access_block = true
#
#   ### S3 Extended Configurations ###
#
#   # S3 Bucket Website Configuration - OPTIONAL
#   set_s3_bucket_website_configuration = false
#
#   # S3 Bucket Policy for Website - OPTIONAL
#   set_s3_bucket_policy_for_website = false
#   s3_bucket_website_policy_file    = ""
#   cloudfront_oai_arn = ""
#
#   # S3 Bucket Policy for CloudFront - OPTIONAL
#   set_s3_bucket_policy_for_cloudfront = true
#   s3_bucket_cloudfront_policy_file    = "s3_cloudfront_policy.json.tpl"
#   cloudfront_arn                      = module.cdn.cdn_arn
#
#   custom_tags = merge({
#     "Name" = "${var.project_name}-${var.branch_name}-cdn-logs"
#   }, var.custom_tags)
# }


resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "labsecs-dummy-test-bucket"

  tags = {
    Name = "cloudfront-logs"
  }
}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.cloudfront_logs.id
  acl    = "private"
}

# resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#
#   bucket = aws_s3_bucket.cloudfront_logs.id
#   acl = "private"
# }
# resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
#
#   bucket = aws_s3_bucket.cloudfront_logs.id
#
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
#
# }
resource "aws_s3_bucket_policy" "cloudfront_logs_policy" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowCloudFrontToWriteLogs",
        Effect: "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudfront_logs.arn}/*",
        Condition = {
          "StringEquals": {
            "AWS:SourceArn": module.cdn.cdn_arn
          }
        }
      }
    ]
  })
}

# --------------------------------------------------------------
# CDN & DNS
# --------------------------------------------------------------
module "cdn" {
  source = "./modules/singularbit/cdn"

  depends_on = [
    module.alb,
    module.acm_certificate_4_cdn
  ]

  alb_dns_name = module.alb.aws_alb_dns_name
  aws_alb_id   = module.alb.aws_alb_id
  alias        = var.project_name

  acm_certificate_arn = module.acm_certificate_4_cdn.acm_certificate_arn

  hosted_zone_id   = data.aws_route53_zone.route53_zone.id
  hosted_zone_name = data.aws_route53_zone.route53_zone.name

#   s3_cdn_logs_domain_name = module.s3_4_cdn_logs.s3_domain_name
  s3_cdn_logs_domain_name = aws_s3_bucket.cloudfront_logs.bucket_domain_name
  s3_cdn_logs_prefix      = "${var.project_name}-${var.branch_name}-${local.acc_4_chars}"
  s3_cdn_include_cookies  = false

  #   s3_regional_domain_name = module.s3_4_static_website.s3_domain_name
  #   s3_failover_domain_name = module.s3_4_static_website_failover.s3_domain_name
  # #  s3_regional_domain_name = module.s3_4_static_website.s3_website_domain
  # #  s3_failover_domain_name = module.s3_4_static_website_failover.s3_website_domain
  #
  #   default_root_object = var.static_website_cdn_default_root_object
  #
  # #  cloudfront_alias = var.static_website_repository_branch
  #   cloudfront_alias = var.static_website_subdomain
  #   hosted_zone_name = var.hosted_zone_name
  # #  hosted_zone_id   = var.hosted_zone_id
  #   hosted_zone_id   = data.aws_route53_zone.route53_zone.id
  #
  #   # Created in a previous module
  #

  tags = merge({
    "Name" = "${var.project_name}-${var.branch_name}-${local.acc_4_chars}"
  }, var.custom_tags)
}