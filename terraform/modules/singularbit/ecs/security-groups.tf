# ----------------------------------------------
# Security Group for the VPC
# ----------------------------------------------
resource "aws_security_group" "this" {

  name = join("", ["${var.project_name}-${var.branch_name}-${local.vpc_suffix}", "-ecs"])
  description = join(" ", ["SG for", var.project_name, "-", var.branch_name, "-", local.vpc_suffix, "ECS"])

  #   vpc_id = module.vpc_4_ecs.vpc_id
  vpc_id = var.vpc_id

  tags = var.custom_tags
}

# ----------------------------------------------
# Security Group Rules for the VPC
# ----------------------------------------------
resource "aws_security_group_rule" "ecs_alb_ingress" {
  description              = "Allow traffic from ALB to ECS"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.alb_security_group_id
}
resource "aws_security_group_rule" "ecs_task_ingress" {
  description              = "Allow traffic from ECS Service Task to ECS"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = aws_security_group.this.id
}
resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}