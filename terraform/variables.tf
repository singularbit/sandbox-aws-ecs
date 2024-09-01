## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## GLOBAL VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "custom_tags" {
  description = "Custom tags to apply to all resources"
  type        = map(any)
  default     = {}
}
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = ""
}
variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}
variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = ""
}
variable "branch_name" {
  description = "The name of the branch"
  type        = string
  default     = ""
}

## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## CLOUDFORMATION IMPORTS
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "cloudformation_stack_name" {
  description = "The name of the CloudFormation stack"
  type        = string
  default     = ""
}

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# Route53
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "route53_zone_name" {
  description = "The name of the Route53 zone"
  type        = string
  default     = ""
}



## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## VARIABLES - VPC - GRAFANA
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "vpc_cidr_4_ecs" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}
variable "public_subnets_4_ecs" {
  description = "Subnets of the Public Subnets CIDRs"
  type        = list(string)
  default     = []
}
variable "private_subnets_4_ecs" {
  description = "Subnets of the Private Subnets CIDRs"
  type        = list(string)
  default     = []
}
variable "database_subnets_4_ecs" {
  description = "Subnets of the Database Subnets CIDRs"
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# VARIABLES - STATIC WEBSITE(S)
# ---------------------------------------------------------------------------------------------------------------------
variable "static_websites_variables" {
  description = "Static Website Variables"
  type        = map(object({
    static_website_route53_zone_name       = string
    static_website_subdomain               = string
    static_website_repository_branch       = string
    static_website_index_document          = string
    static_website_error_document          = string
    static_website_cdn_default_root_object = string

    static_website_account_id                            = string
    static_website_region                                = string
    static_website_repository_name                       = string
    static_website_pipeline_codestar_connection_name     = string
    static_website_pipeline_codestar_connection_provider = string
    static_website_pipeline_build_stages                 = map(any)
  }))
  default = {}
}


# Unsorted

variable "ecs_instance_type" {
  description = "The instance type for the ECS cluster"
  type        = string
  default     = "t2.micro"
}
variable "ecs_image_id" {
  description = "The AMI ID for the ECS cluster"
  type        = string
  default     = ""
}
variable "alb_target_group_name" {
  description = "The name of the target group"
  type        = string
  default     = "ecs_target_group"
}
variable "ecs_container_port" {
  description = "The port for the ECS container"
  type        = number
  default     = 80
}
variable "service_name" {
  description = "The name of the service"
  type        = string
  default     = "ecs_service"
}
variable "ecs_service_image_name" {
  description = "The name of the image"
  type        = string
  default     = "nginx"
}
variable "http_rule_description" {
  description = "The description of the HTTP rule"
  type        = string
  default     = "HTTP rule"
}
variable "http_rule_cidr_blocks" {
  description = "The CIDR blocks for the HTTP rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}