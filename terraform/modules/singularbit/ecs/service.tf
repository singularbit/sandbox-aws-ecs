# ----------------------------------------------
#  ECS Service
# ----------------------------------------------
resource "aws_ecs_service" "main" {
  name                = var.service_name
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.this.arn
  desired_count       = var.service_desired_count
  iam_role            = var.network_mode == "awsvpc" ? null : aws_iam_role.service_role.arn
  scheduling_strategy = var.scheduling_strategy
  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]
    subnets          = var.private_subnets
  }
}

# ----------------------------------------------
# IAM ECS Service Role
# ----------------------------------------------
resource "aws_iam_role" "service_role" {
  name               = join("", [var.service_name, "-instance-role"])
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.service_role_policy.json

  tags = var.custom_tags
}

# ----------------------------------------------
# IAM ECS Service Role Policy Document
# ----------------------------------------------
data "aws_iam_policy_document" "service_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

# ----------------------------------------------
# IAM ECS Service Role Policy
# ----------------------------------------------
resource "aws_iam_role_policy" "instance_role_policy" {
  name   = join("", [var.service_name, "-instance-role-policy"])
  role   = aws_iam_role.service_role.id
#   policy = data.aws_iam_policy_document.instance_policy.json
  policy = data.aws_iam_policy_document.role_policy.json
}

# ----------------------------------------------
# IAM ECS Service Role Policy Document
# ----------------------------------------------
data "aws_iam_policy_document" "role_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]
    resources = ["*"]
  }
}


/*
# ecs-service/main.tf
provider "aws" {
  region = var.region
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  container_definitions    = jsonencode(var.container_definitions)
  execution_role_arn       = var.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
}

# Outputs
output "service_name" {
  value = aws_ecs_service.this.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}



# ecs-service/main.tf
resource "aws_lb_target_group" "this" {
  name     = "${var.service_name}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

 */

















