# ----------------------------------------------
# ECS Cluster
# ----------------------------------------------
resource "aws_ecs_cluster" "ecs_cluster" {

  name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"

  tags = var.custom_tags

}


/*
# ecs-cluster/main.tf
provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.cluster_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# Outputs
output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
 */











