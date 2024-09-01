# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# AWS Basic
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
data "aws_default_tags" "default" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# AWS Route53
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
data "aws_route53_zone" "route53_zone" {
  name         = var.route53_zone_name
  private_zone = false
}


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# CloudFormation Outputs - Terraform Pipeline & Prerequisites
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
data "aws_cloudformation_export" "codepipeline_role_arn" {
  name = "${var.cloudformation_stack_name}-CodePipelineRole"
}
data "aws_cloudformation_export" "codebuild_role_arn" {
  name = "${var.cloudformation_stack_name}-CodeBuildRole"
}


# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

# data "aws_route_table" "vpc_peering_route_table" {
#   route_table_id = var.route_table_id
# }
# data "aws_security_group" "database_security_group" {
#   id = var.database_security_group
# }
