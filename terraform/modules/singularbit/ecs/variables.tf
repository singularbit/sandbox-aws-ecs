
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## GLOBAL VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "custom_tags" {
  description = "Custom tags to apply to all resources"
  type        = map(any)
  default     = {}
}
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = ""
}
variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}
variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = ""
}
variable "branch_name" {
  description = "The name of the branch"
  type        = string
  default     = ""
}

## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## VPC VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = ""
}
variable "private_subnets" {
  description = "The IDs of the private subnets"
  type        = list(string)
  default     = []
}


## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## ALB VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
variable "alb_target_group_name" {
  description = "The name of the target group"
  type        = string
  default     = ""
}
variable "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  type        = string
  default     = ""
}
variable "tg_health_check_path" {
  description = "The health check path for the target group"
  type        = string
  default     = "/"
}
variable "path_pattern" {
  description = "The path pattern to match"
  type        = string
  default     = ""
}
variable "alb_security_group_id" {
  description = "The ID of the security group for the ALB"
  type        = string
  default     = ""
}
variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = ""
}

## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## ECS VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------

variable "attach_efs" {
  description = "Whether to attach an EFS volume to the ECS task"
  type        = bool
  default     = false
}
variable "efs_id" {
  description = "The ID of the EFS volume"
  type        = string
  default     = ""
}
variable "depends_on_efs" {
  description = "Whether the ECS task depends on the EFS volume"
  type        = bool
  default     = false
}
variable "image_id" {
  description = "The ID of the Docker image"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "The instance type for the ECS task"
  type        = string
  default     = "t2.micro"
}
variable "efs_sg_id" {
  description = "The ID of the security group for the EFS volume"
  type        = string
  default     = ""
}
variable "key_name" {
  description = "The name of the key pair to use for the ECS task"
  type        = string
  default     = ""
}
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the ECS task"
  type        = bool
  default     = false
}
variable "additional_iam_policy_statements" {
  description = "Additional IAM policy statements to attach to the ECS task"
  type        = list(string)
  default     = []
}

## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
## ECS SERVICE VARIABLES
## ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
  default     = ""
}
variable "exec_iam_policies" {
  description = "The IAM policies to attach to the ECS task"
  type        = list(string)
  default     = []
}
variable "task_iam_policies" {
  description = "The IAM policies to attach to the ECS task"
  type        = list(string)
  default     = []
}
variable "network_mode" {
  description = "The network mode for the ECS task"
  type        = string
  default     = "awsvpc"
}
variable "image_name" {
  description = "The name of the Docker image"
  type        = string
  default     = ""
}
variable "service_cpu" {
  description = "The number of CPU units to allocate to the ECS task"
  type        = number
  default     = 256
}
variable "service_memory" {
  description = "The amount of memory to allocate to the ECS task"
  type        = number
  default     = 512
}
variable "memory_reservation" {
  description = "The amount of memory to reserve for the ECS task"
  type        = number
  default     = 256
}
variable "essential" {
  description = "Whether the ECS task is essential"
  type        = bool
  default     = true
}
variable "privileged" {
  description = "Whether the ECS task is privileged"
  type        = bool
  default     = false
}
variable "command" {
  description = "The command to run in the ECS task"
  type        = list(string)
  default     = []
}
variable "port_mappings" {
  description = "The port mappings for the ECS task"
  type        = list(object({
    container_port = number
    host_port      = number
    protocol       = string
  }))
  default     = []
}
variable "mount_points" {
  description = "The mount points for the ECS task"
  type        = list(object({
    container_path = string
    source_volume  = string
    read_only      = bool
  }))
  default     = []
}
variable "environment" {
  description = "The environment variables for the ECS task"
  type        = map(string)
  default     = {}
}
variable "linux_parameters" {
  description = "The Linux parameters for the ECS task"
  type        = object({
    capabilities = object({
      add = list(string)
      drop = list(string)
    })
  })
  default     = {
    capabilities = {
      add = []
      drop = []
    }
  }
}
variable "log_configuration" {
  description = "The log configuration for the ECS task"
  type        = object({
    log_driver = string
    options    = map(string)
  })
  default     = {
    log_driver = "awslogs"
    options    = {
      "awslogs-group"         = "/ecs"
      "awslogs-region"        = "eu-west-1"
      "awslogs-stream-prefix" = "ecs"
    }
  }
}
variable "ulimits" {
  description = "The ulimits for the ECS task"
  type        = list(object({
    name      = string
    soft_limit = number
    hard_limit = number
  }))
  default     = []
}
variable "repository_credentials" {
  description = "The repository credentials for the ECS task"
  type        = object({
    credentials_parameter = string
  })
  default     = {
    credentials_parameter = ""
  }
}
variable "volumes" {
  description = "The volumes for the ECS task"
  type        = list(object({
    name = string
    host = object({
      source_path = string
    })
  }))
  default     = []
}
variable "service_desired_count" {
  description = "The desired count for the ECS service"
  type        = number
  default     = 1
}
variable "scheduling_strategy" {
  description = "The scheduling strategy for the ECS service"
  type        = string
  default     = "REPLICA"
}
variable "ecs_container_name" {
  description = "The name of the ECS container"
  type        = string
  default     = ""
}
variable "ecs_container_port" {
  description = "The port of the ECS container"
  type        = number
  default     = 80
}

variable "name" {
  description = "The name of the ECS container"
  type        = string
  default     = ""
}
variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
  default     = []
}
variable "min_size" {
  description = "The minimum size of the ECS service"
  type        = number
  default     = 1
}
variable "max_size" {
  description = "The maximum size of the ECS service"
  type        = number
  default     = 1
}
variable "health_check_type" {
  description = "The type of health check to perform"
  type        = string
  default     = "EC2"
}
variable "health_check_grace_period" {
  description = "The grace period for the health check"
  type        = number
  default     = 300
}
variable "termination_policies" {
  description = "The termination policies for the ECS service"
  type        = list(string)
  default     = []
}
variable "aws_alb_arn" {
  description = "The ARN of the ALB"
  type        = string
  default     = ""
}
variable "acm_cert_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default     = ""
}
variable "aws_alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  type        = string
  default     = ""
}
variable "evaluation_period" {
  description = "The evaluation period for the CloudWatch alarm"
  type        = number
  default     = 1
}
variable "statistic_period" {
  description = "The statistic period for the CloudWatch alarm"
  type        = number
  default     = 60
}
variable "actions_alarm" {
  description = "The actions to take when the CloudWatch alarm is triggered"
  type        = list(object({
    type = string
    arn  = string
  }))
  default     = []
}
variable "actions_ok" {
  description = "The actions to take when the CloudWatch alarm is OK"
  type        = list(object({
    type = string
    arn  = string
  }))
  default     = []
}
variable "response_time_threshold" {
  description = "The response time threshold for the CloudWatch alarm"
  type        = number
  default     = 500
}
variable "unhealthy_hosts_threshold" {
  description = "The unhealthy hosts threshold for the CloudWatch alarm"
  type        = number
  default     = 1
}
variable "healthy_hosts_threshold" {
  description = "The healthy hosts threshold for the CloudWatch alarm"
  type        = number
  default     = 1
}
variable "description" {
  description = "The description of the CloudWatch alarm"
  type        = string
  default     = ""
}
variable "self" {
  description = "Whether to reference the ECS service itself"
  type        = bool
  default     = false
}
variable "from_port" {
  description = "The from port for the security group rule"
  type        = number
  default     = 80
}
variable "to_port" {
  description = "The to port for the security group rule"
  type        = number
  default     = 80
}
variable "protocol" {
  description = "The protocol for the security group rule"
  type        = string
  default     = "TCP"
}
variable "cidr_blocks" {
  description = "The CIDR blocks for the security group rule"
  type        = list(string)
  default     = []
}
variable "desired_capacity" {
  description = "The desired capacity for the ECS service"
  type        = number
  default     = 1
}