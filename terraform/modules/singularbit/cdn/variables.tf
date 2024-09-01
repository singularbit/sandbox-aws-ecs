variable "tags" {
  description = "Custom tags to apply to all resources"
  type        = map(any)
  default = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# CloudFront Distribution
# ---------------------------------------------------------------------------------------------------------------------
variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
  default     = ""
}
variable "aws_alb_id" {
  description = "The ID of the ALB"
  type        = string
  default     = ""
}
variable "alias" {
  description = "The alias for the CloudFront distribution"
  type        = string
  default     = ""
}
variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
  default     = ""
}
variable "s3_cdn_logs_domain_name" {
  description = "The domain name of the S3 bucket for CDN logs"
  type        = string
  default     = ""
}
variable "s3_cdn_logs_prefix" {
  description = "The prefix for CDN logs"
  type        = string
  default     = ""
}
variable "s3_cdn_include_cookies" {
  description = "Whether to include cookies in CDN logs"
  type        = bool
  default     = false
}
variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# ACM Certificate
# ---------------------------------------------------------------------------------------------------------------------
variable "hosted_zone_id" {
  description = "The ID of the hosted zone"
  type        = string
  default     = ""
}


### BELOW IS THE CODE FOR THE CLOUDFRONT DISTRIBUTION FOR S3 BUCKET

# variable "s3_regional_domain_name" {
#   description = "The regional domain name of the S3 bucket"
#   type        = string
#   default     = ""
# }
# variable "s3_failover_domain_name" {
#   description = "The failover domain name of the S3 bucket"
#   type        = string
#   default     = ""
# }

# variable "default_root_object" {
#   description = "The default root object"
#   type        = string
#   default     = ""
# }
# variable "cloudfront_alias" {
#   description = "The alias for the CloudFront distribution"
#   type        = string
#   default     = ""
# }




