# resource "aws_iam_policy" "ecs_cloudwatch_policy" {
#   name        = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-cloudwatch-policy"
#   description = "IAM policy for ECS to write logs to CloudWatch"
#   policy      = templatefile("${path.module}/templates/ECS-CloudWatchLogs-IAM-Policy.json.tpl", {})
# }
#
# resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
#   policy_arn = aws_iam_policy.ecs_cloudwatch_policy.arn
#   role       = aws_iam_role.this.name
# }
#
# resource "aws_cloudwatch_log_group" "alb_log_group" {
#   name              = "${var.service_name}-cloudwatch-log-group"
#   retention_in_days = 365
#
#   tags = merge({
#     "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
#   }, local.custom_tags)
# }
#
# resource "aws_cloudwatch_log_stream" "alb_log_stream" {
#   name           = "${var.service_name}-cloudwatch-log-stream"
#   log_group_name = aws_cloudwatch_log_group.alb_log_group.name
# }
#
# resource "aws_cloudwatch_metric_alarm" "httpcode_target_5xx_count" {
#   alarm_name          = "${var.service_name}-httpcode_target_5xx_count"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = var.evaluation_period
#   metric_name         = "HTTPCode_Target_5XX_Count"
#   namespace           = "AWS/ApplicationELB"
#   period              = var.statistic_period
#   statistic           = "Sum"
#   threshold           = "0"
#   alarm_description   = "Alarm when the number of 5xx HTTP codes is greater than 0"
#   alarm_actions       = var.actions_alarm
#   ok_actions          = var.actions_ok
#
#   dimensions = {
#     LoadBalancer = var.aws_alb_arn_suffix
#     TargetGroup  = aws_alb_target_group.alb_target_group.arn_suffix
#   }
#
#     tags = merge({
#     "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
#   }, local.custom_tags)
# }
#
# resource "aws_cloudwatch_metric_alarm" "target_response_time_average" {
#     alarm_name          = "${var.service_name}-target_response_time_average"
#     comparison_operator = "GreaterThanOrEqualToThreshold"
#     evaluation_periods  = var.evaluation_period
#     metric_name         = "TargetResponseTime"
#     namespace           = "AWS/ApplicationELB"
#     period              = var.statistic_period
#     statistic           = "Average"
#     threshold           = var.response_time_threshold
#     alarm_description   = format("Alarm when the average response time is greater than %s seconds",var.response_time_threshold)
#     alarm_actions       = var.actions_alarm
#     ok_actions          = var.actions_ok
#
#     dimensions = {
#         LoadBalancer = var.aws_alb_arn_suffix
#         TargetGroup  = aws_alb_target_group.alb_target_group.arn_suffix
#     }
#
#   tags = merge({
#     "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
#   }, local.custom_tags)
# }
#
# resource "aws_cloudwatch_metric_alarm" "target_unhealthy_host_count" {
#     alarm_name          = "${var.service_name}-target_unhealthy_host_count"
#     comparison_operator = "GreaterThanOrEqualToThreshold"
#     evaluation_periods  = var.evaluation_period
#     metric_name         = "TargetUnhealthyHostCount"
#     namespace           = "AWS/ApplicationELB"
#     period              = var.statistic_period
#     statistic           = "Sum"
#     threshold           = var.unhealthy_host_threshold
#     alarm_description   = format("Unhealthy host count is greater than %s",var.unhealthy_host_threshold)
#     alarm_actions       = var.actions_alarm
#     ok_actions          = var.actions_ok
#
#     dimensions = {
#         LoadBalancer = var.aws_alb_arn_suffix
#         TargetGroup  = aws_alb_target_group.alb_target_group.arn_suffix
#     }
#     tags = merge({
#     "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
#   }, local.custom_tags)
# }
#
# resource "aws_cloudwatch_metric_alarm" "CPU_too_high" {
#     alarm_name          = "${var.service_name}-CPU_too_high"
#     comparison_operator = "GreaterThanOrEqualToThreshold"
#     evaluation_periods  = "1"
#     metric_name         = "CPUUtilization"
#     namespace           = "AWS/ECS"
#     period              = "300"
#     statistic           = "Average"
#     threshold           = "80"
#     alarm_description   = "Alarm when the average CPU utilization is greater than 80 percent"
#     alarm_actions       = var.actions_alarm
#     ok_actions          = var.actions_ok
#
#     dimensions = {
#        AutoScalingGroupName = aws_autoscaling_group.this.id
#     }
#
#     tags = merge({
#     "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
#   }, local.custom_tags)
# }
#
#
# locals{
#
#   # Copilot generated dashboard widgets
#   dashboard_widgets = [
#     {
#       type = "text",
#       x    = 0,
#       y    = 0,
#       width = 24,
#       height = 1,
#       properties = {
#         markdown = "# ECS Dashboard"
#       }
#     },
#     {
#       type = "metric",
#       x    = 0,
#       y    = 1,
#       width = 24,
#       height = 6,
#       properties = {
#         metrics = [
#           [ "AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", "${var.aws_alb_arn_suffix}", "TargetGroup", "${aws_alb_target_group.alb_target_group.arn_suffix}", { "stat": "Sum", "period": "${var.statistic_period}" } ],
#           [ ".", "TargetResponseTime", ".", ".", ".", ".", { "stat": "Average", "period": "${var.statistic_period}" } ],
#           [ ".", "TargetUnhealthyHostCount", ".", ".", ".", ".", { "stat": "Sum", "period": "${var.statistic_period}" } ],
#           [ "AWS/ECS", "CPUUtilization", "AutoScalingGroupName", "${aws_autoscaling_group.this.id}", ".", ".", { "stat": "Average", "period": "300" } ]
#         ],
#         view = "timeSeries",
#         stacked = false,
#         region = "us-west-2",
#         title = "ECS Metrics",
#         period = "${var.statistic_period}",
#         yAxis = {
#           left: {
#             label: "Value",
#           },
#           right: {
#             label: "Value",
#           }
#         },
#         annotations = {
#           horizontal: [
#             {
#               label: "Alarm Threshold",
#               value: "${var.response_time_threshold}",
#               color: "#ff0000"
#             }
#           ]
#         }
#       }
#     }
#   ]
# }
# resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
#   dashboard_name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-ecs-dashboard"
#   dashboard_body = jsonencode({
#     widgets = local.dashboard_widgets
#   })
# }
#
