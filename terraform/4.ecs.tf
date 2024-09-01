/*
# main.tf
provider "aws" {
  region = "us-west-2"
}

module "ecs_cluster" {
  source       = "./ecs-cluster"
  cluster_name = "my-cluster"
  region       = "us-west-2"
}

module "ecs_service" {
  source             = "./ecs-service"
  cluster_id         = module.ecs_cluster.cluster_id
  task_family        = "my-task"
  container_definitions = [
    {
      name  = "my-container"
      image = "nginx"
      cpu   = 256
      memory = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ]
  execution_role_arn = module.ecs_cluster.task_execution_role_arn
  service_name       = "my-service"
  desired_count      = 2
  target_group_arn   = aws_lb_target_group.main.arn
  container_name     = "my-container"
  container_port     = 80
  subnets            = ["subnet-12345", "subnet-67890"]
  security_groups    = ["sg-01234567"]
}

# Loop over each service definition in the ecs_services variable
module "ecs_services" {
  source = "./ecs-service"

  for_each = var.ecs_services

  cluster_id         = module.ecs_cluster.cluster_id
  task_family        = each.value.task_family
  container_definitions = each.value.container_definitions
  execution_role_arn = module.ecs_cluster.task_execution_role_arn
  service_name       = each.key  # Use the key as the service name
  desired_count      = each.value.desired_count
  target_group_arn   = each.value.target_group_arn
  container_name     = each.value.container_name
  container_port     = each.value.container_port
  subnets            = each.value.subnets
  security_groups    = each.value.security_groups
}


module "ecs_services" {
  source = "./ecs-service"

  for_each = var.ecs_services

  cluster_id         = module.ecs_cluster.cluster_id
  task_family        = each.value.task_family
  container_definitions = each.value.container_definitions
  execution_role_arn = module.ecs_cluster.task_execution_role_arn
  service_name       = each.key
  desired_count      = each.value.desired_count
  container_port     = each.value.container_port
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.subnet_ids
  security_groups    = module.security_groups.security_group_ids
}

 */