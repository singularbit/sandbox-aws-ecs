## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## GLOBAL VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "tags" {
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



# Unsorted

variable "hosted_zone_id" {
  description = "The hosted zone ID"
  type        = string
  default     = ""
}
variable "hosted_zone_name" {
  description = "The hosted zone name"
  type        = string
  default     = ""
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = ""
}
variable "vpc_id" {
  description = "The VPC ID to deploy the ALB to"
  type        = string
  default     = ""
}
variable "public_subnets" {
  description = "The public subnets to deploy the ALB to"
  type        = list(string)
  default     = []
}

variable "alb_acl_name" {
  description = "The name of the ALB ACL"
  type        = string
  default     = ""
}
variable "alb_acl_description" {
  description = "The description of the ALB ACL"
  type        = string
  default  =   ""
}
variable "alb_acl_scope" {
  description = "The scope of the ALB ACL"
  type        = string
  default   =  ""
}
