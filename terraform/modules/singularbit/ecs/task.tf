# -----------------------------
# ECS Task Definition
# -----------------------------
resource "aws_ecs_task_definition" "this" {

  family                = var.service_name
  execution_role_arn    = aws_iam_role.ecs_exec_role.arn
  task_role_arn         = var.task_iam_policies == null ? null : aws_iam_role.task_role[0].arn
  network_mode          = var.network_mode
  container_definitions = jsonencode([
    {
      name                  = var.service_name
      image                 = var.image_name
      cpu                   = var.service_cpu
      memory                = var.service_memory
      memoryReservation     = var.memory_reservation
      essential             = var.essential
      privileged            = var.privileged
      command               = var.command
      portMappings          = var.port_mappings
      mountPoints           = var.mount_points
      environment           = var.environment
      linuxParameters       = var.linux_parameters
      logConfiguration      = var.log_configuration
      ulimits               = var.ulimits
      repositoryCredentials = var.repository_credentials
    }
  ])

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }
    }
  }

  tags = var.custom_tags
}


# -----------------------------
# IAM Role for ECS Task Execution
# -----------------------------
resource "aws_iam_role" "ecs_exec_role" {

  name               = join("", [var.service_name, "-ecs-exec-role"])
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_exec_assume_role_policy.json

  tags = var.custom_tags
}

# -----------------------------
# IAM Policy Document for ECS Task Execution
# -----------------------------
data "aws_iam_policy_document" "ecs_exec_assume_role_policy" {
  statement {
    #     effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# -----------------------------
# IAM Role Policy for ECS Task Execution
# -----------------------------
resource "aws_iam_role_policy" "ecs_exec_role_policy" {
  name   = join("", [var.service_name, "-ecs-exec-role-policy"])
  role   = aws_iam_role.ecs_exec_role.id
  policy = data.aws_iam_policy_document.ecs_exec_policy.json
}

# -----------------------------
# IAM Policy Document for ECS Task Execution
# -----------------------------
data "aws_iam_policy_document" "ecs_exec_policy" {

  statement {
    effect  = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.exec_iam_policies

    content {
      effect    = lookup(statement.value, "effect", null)
      actions   = lookup(statement.value, "actions", null)
      resources = lookup(statement.value, "resources", null)
    }
  }
}


# -----------------------------
# IAM Role for ECS Task
# -----------------------------
resource "aws_iam_role" "task_role" {

  count = var.task_iam_policies == null ? 0 : 1

  name = join("", [var.service_name, "-task-role"])
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy[0].json

  tags = var.custom_tags
}

# -----------------------------
# IAM Policy Document for ECS Task
# -----------------------------
data "aws_iam_policy_document" "task_assume_role_policy" {
  count = var.task_iam_policies == null ? 0 : 1

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

# -----------------------------
# IAM Role Policy for ECS Task
# -----------------------------
resource "aws_iam_role_policy" "task_role_policy" {

  count = var.task_iam_policies == null ? 0 : 1

  name   = join("", [var.service_name, "-task-role-policy"])
  role   = aws_iam_role.task_role[0].id
#   policy = data.aws_iam_policy_document.task_policy[0].json
  policy = data.aws_iam_policy_document.task_role_policy[0].json
#   policy = data.aws_iam_policy_document.role_policy[0].json
}

# -----------------------------
# IAM Policy Document for ECS Task
# -----------------------------
data "aws_iam_policy_document" "task_role_policy" {
  count = var.task_iam_policies == null ? 0 : 1

  dynamic "statement" {
    for_each = var.task_iam_policies

    content {
      effect    = lookup(statement.value, "effect", null)
      actions   = lookup(statement.value, "actions", null)
      resources = lookup(statement.value, "resources", null)
    }
  }
}
