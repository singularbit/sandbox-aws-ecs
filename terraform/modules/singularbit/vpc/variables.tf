# variable "region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-west-2"
# }
#
# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
#   default     = "10.0.0.0/16"
# }
#
# variable "public_subnets" {
#   description = "Public subnets CIDR blocks"
#   type        = map(string)
#   default     = {
#     "us-west-2a" = "10.0.1.0/24"
#     "us-west-2b" = "10.0.2.0/24"
#   }
# }
#
# variable "private_subnets" {
#   description = "Private subnets CIDR blocks"
#   type        = map(string)
#   default     = {
#     "us-west-2a" = "10.0.3.0/24"
#     "us-west-2b" = "10.0.4.0/24"
#   }
# }
#
# variable "nat_gateway_enabled" {
#   description = "Enable or disable the NAT Gateway"
#   type        = bool
#   default     = true
# }
#
# variable "flow_log_destination" {
#   description = "CloudWatch log group for VPC flow logs"
#   type        = string
# }
#
# variable "tags" {
#   description = "Tags to apply to resources"
#   type        = map(string)
#   default     = {
#     "Environment" = "dev"
#     "Project"     = "vpc-setup"
#   }
# }
#
# variable "name_prefix" {
#   description = "Name prefix for resources"
#   type        = string
#   default     = "my-vpc"
# }