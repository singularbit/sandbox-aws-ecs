# ----------------------------------------------
# ECS Cluster
# ----------------------------------------------
resource "aws_ecs_cluster" "ecs_cluster" {

  name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"

  tags = var.custom_tags

}














