# ---------------------------------------------------------------------------------------------------------------------
# CloudFront Distribution
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "Origin" #var.aws_alb_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "LabsECS CloudFront Distribution"
  default_root_object = "index.html"

  aliases = ["${var.alias}.${var.hosted_zone_name}"]

  default_cache_behavior {
    target_origin_id       = "Origin" #var.aws_alb_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
#     lambda_function_association {
#       event_type   = "origin-request"
#       lambda_arn   = "arn:aws:lambda:us-east-1:123456789012:function:MyLambdaFunction"
#       include_body = false
#     }
  }

  logging_config {
    bucket          = var.s3_cdn_logs_domain_name
    prefix          = var.s3_cdn_logs_prefix
    include_cookies = var.s3_cdn_include_cookies
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = var.tags
}


### BELOW IS THE CODE FOR THE CLOUDFRONT DISTRIBUTION FOR S3 BUCKET

# # Depends on DNS, S3
# resource "aws_cloudfront_distribution" "cloudfront_distribution" {
#
#   origin_group {
#     origin_id = "groupS3"
# #    origin_id = "origin_group"
#
#     failover_criteria {
#       status_codes = [403, 404, 500, 502]
#     }
#
#     member {
#       origin_id = "primaryS3"
# #      origin_id = var.s3_regional_domain_name
#     }
#
#     member {
#       origin_id = "failoverS3"
# #      origin_id = var.s3_regional_domain_name
#     }
#   }
#
#   origin {
#     domain_name = var.s3_regional_domain_name
#     origin_id   = "primaryS3" #var.s3_regional_domain_name
# #    origin_id   = var.s3_regional_domain_name
#
#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.cdn_oai.cloudfront_access_identity_path
#     }
#   }
#
#   origin {
#     domain_name = var.s3_regional_domain_name
#     origin_id   = "failoverS3"
# #    origin_id   = var.s3_regional_domain_name
#
#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.cdn_oai.cloudfront_access_identity_path
#     }
#   }
#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = "primaryS3" #var.s3_regional_domain_name
# #    target_origin_id       = var.s3_regional_domain_name
#     viewer_protocol_policy = "redirect-to-https"
#     compress               = true
#     //    min_ttl = 0
#     //    default_ttl = 3600
#     //    max_ttl = 86400
#     cache_policy_id        = data.aws_cloudfront_cache_policy.cloudfront_cache_policy.id
#     //    forwarded_values {
#     //      query_string = false
#     //
#     //      cookies {
#     //        forward = "none"
#     //      }
#     //    }
#   }
#
#   enabled             = true
#   default_root_object = var.default_root_object
#   is_ipv6_enabled     = false
#   # TODO: (2024-02-09) Change the logic to use more than one alias
#   aliases             = ["${var.cloudfront_alias}.${var.hosted_zone_name}"]
#   price_class         = "PriceClass_100"
#   # Commented web_acl_id for now (20220728). Costs $0.74/day.
#   //  web_acl_id = var.web_acl_id
#
#   logging_config {
#     include_cookies = true
#     bucket          = var.s3_cdn_logs_domain_name
#     prefix          = var.s3_cdn_logs_prefix
#   }
#
#
#   restrictions {
#     geo_restriction {
#       restriction_type = "whitelist"
#       locations        = ["GB", "PT", "PL"]
#     }
#   }
#
#   viewer_certificate {
#     acm_certificate_arn      = var.acm_certificate_arn
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }
#
#   custom_error_response {
#     error_code            = 403
#     error_caching_min_ttl = 0
#     response_page_path    = "/index.html"
#     response_code         = 200
#   }
#
#   //  default_cache_behavior {
#   //    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#   //    cached_methods   = ["GET", "HEAD"]
#   //    target_origin_id = aws_s3_bucket.s3_bucket_cdn_log.id
#   //
#   //    forwarded_values {
#   //      query_string = false
#   //
#   //      cookies {
#   //        forward = "none"
#   //      }
#   //    }
#   //
#   //    viewer_protocol_policy = "allow-all"
#   //    min_ttl                = 0
#   //    default_ttl            = 3600
#   //    max_ttl                = 86400
#   //  }
#
#   tags = var.custom_tags
#
# }
#
# resource "aws_cloudfront_origin_access_identity" "cdn_oai" {
#
#   comment = "access-identity-${var.s3_regional_domain_name}"
# }