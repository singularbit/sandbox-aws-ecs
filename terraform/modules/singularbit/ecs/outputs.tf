output "alb_target_group_arn" {
  value = aws_alb_target_group.alb_target_group[*]
}

/*
output "ecs_service_target_group_arns" {
  value = { for svc, mod in module.ecs_services : svc => mod.target_group_arn }
}

 */