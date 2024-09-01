# ----------------------------------------------
# Autoscaling Group
# ----------------------------------------------
resource "aws_autoscaling_group" "autoscaling_group" {

  name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"

  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = [
    var.private_subnets[0]
  ]
  launch_configuration = aws_launch_configuration.launch_configuration.name
  lifecycle {
    create_before_destroy = true
  }

}

# ----------------------------------------------
# Launch Configuration
# ----------------------------------------------
locals {
  userdata = templatefile("${path.module}/templates/user_data.tpl", {
    attach_efs       = var.attach_efs
    ecs_cluster_name = aws_ecs_cluster.ecs_cluster.name
    efs_id           = var.efs_id
    depends_on       = false #join("", var.depends_on_efs)
  })
}
resource "aws_launch_configuration" "launch_configuration" {

  name_prefix     = join("", ["${var.project_name}-${var.branch_name}-${local.vpc_suffix}", "-"])
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = (length(var.efs_sg_id) > 0 ? [
    aws_security_group.this.id, var.efs_sg_id
  ] :
    [
      aws_security_group.this.id
    ])
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = local.userdata # This associates the Target Group with the ECS Service

  lifecycle {
    create_before_destroy = true
  }

}

# ----------------------------------------------
# IAM Instance Profile
# ----------------------------------------------
resource "aws_iam_instance_profile" "instance_profile" {

  name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"

  role = aws_iam_role.this.name

  tags = var.custom_tags

}

# ----------------------------------------------
# IAM Role 4 IAM Instance Profile
# ----------------------------------------------
resource "aws_iam_role" "this" {

  name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"

  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.custom_tags
}

# ----------------------------------------------
# IAM Policy Document 4 IAM Role 4 IAM Instance Profile
# ----------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    #     effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

# # ----------------------------------------------
# # IAM Role Policy
# # ----------------------------------------------
# resource "aws_iam_role_policy" "this" {
#
#   name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"
#
#   role   = aws_iam_role.this.name
#   policy = data.aws_iam_policy_document.policy.json
#
# }
#
# # ----------------------------------------------
# # IAM Policy Document
# # ----------------------------------------------
# data "aws_iam_policy_document" "policy" {
#   statement {
#     effect  = "Allow"
#     actions = [
#       "ecs:CreateCluster",
#       "ecs:DeregisterContainerInstance",
#       "ecs:DiscoverPollEndpoint",
#       "ecs:Poll",
#       "ecs:RegisterContainerInstance",
#       "ecs:StartTelemetrySession",
#       "ecs:Submit*",
#       "ecs:StartTask",
#       "ecs:ListClusters",
#       "ecs:DescribeClusters",
#       "ecs:RegisterTaskDefinition",
#       "ecs:RunTask",
#       "ecs:StopTask",
#       "ecr:GetAuthorizationToken",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatctGetImage",
#     ]
#     resources = ["*"]
#
#   }
#
#   dynamic "statement" {
#     for_each = var.additional_iam_policy_statements
#     content {
#       effect    = lookup(statement.value, "effect", null)
#       actions   = lookup(statement.value, "actions", null)
#       resources = lookup(statement.value, "resources", null)
#     }
#   }
# }
