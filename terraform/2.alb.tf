# --------------------------------------------------------------
# ALB - Default 400 Listener - ACM Certificate
#
# This module creates an ELB with no target groups.
# A single listener is configured with a default action that returns a 403 response.
# Creates a certificate for the ALB.
# --------------------------------------------------------------
module "alb" {

  depends_on = [
    module.vpc_4_ecs
  ]

  source = "./modules/singularbit/alb"

  #   custom_tags = local.custom_tags

  project_name = var.project_name
  #   account_id   = data.aws_caller_identity.current.account_id
  vpc_id = module.vpc_4_ecs.vpc_id

  public_subnets = module.vpc_4_ecs.public_subnets
  alb_name = "${var.project_name}-${var.branch_name}"
  #   hosted_zone    = var.hosted_zone

  hosted_zone_id   = data.aws_route53_zone.route53_zone.id
  hosted_zone_name = data.aws_route53_zone.route53_zone.name


  #   alb_acl_name        = var.alb_acl_name
  #   alb_acl_description = var.alb_acl_description
  #   alb_acl_scope       = var.alb_acl_scope
  alb_acl_name        = "${var.project_name}-alb-acl-name"
  alb_acl_description = "${var.project_name}-alb-acl-description"
  alb_acl_scope       = "${var.project_name}-alb-acl-scope"

  #   custom_header_name  = var.custom_header_name
  #   custom_header_value = var.custom_header_value

  # Tags ...

  # alb
  tags = merge({
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
  }, local.custom_tags)
}