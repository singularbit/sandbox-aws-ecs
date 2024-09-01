locals {

  vpc_suffix = "ecs"

  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  # Public outbound ACL Rules for the VPC
  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  public_outbound_acl_rules = {
    default_outbound = [
      {
        rule_number = 200
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ]
#     public_outbound = [
#       {
#         rule_number = 100
#         rule_action = "allow"
#         from_port   = 0
#         to_port     = 65535
#         protocol    = "-1"
#         cidr_block  = "${var.vpc_cidr_4_ecs}.0.0/16"
#       }
#     ]
  }


  # # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  # # Default Network ACL Ingress and Egress rules
  # # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  #  default_network_acl_ingress = [
  #    {
  #      action          = "allow"
  #      cidr_block      = "${var.vpc_cidr_4_ecs}.0.0/16"
  #      from_port       = 0
  #      icmp_code       = null
  #      icmp_type       = null
  #      ipv6_cidr_block = null
  #      protocol        = "-1"
  #      rule_no         = 100
  #      to_port         = 0
  #    }
  #  ]
  #  default_network_acl_egress = [
  #    {
  #      action          = "allow"
  #      cidr_block      = "${var.vpc_cidr_4_ecs}.0.0/16"
  #      from_port       = 0
  #      icmp_code       = null
  #      icmp_type       = null
  #      ipv6_cidr_block = null
  #      protocol        = "-1"
  #      rule_no         = 100
  #      to_port         = 0
  #    }
  #  ]

  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  # Default Security Group Ingress and Egress rules
  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  default_security_group_ingress = [
    {
      cidr_blocks      = "${var.vpc_cidr_4_ecs}.0.0/16"
      ipv6_cidr_blocks = ""
      prefix_list_ids  = ""
      security_groups  = ""
      description      = "Allow all traffic to the VPC"
      from_port        = 0
      to_port          = 0
      protocol         = -1
    }
  ]
  default_security_group_egress = [
    {
      cidr_blocks      = "${var.vpc_cidr_4_ecs}.0.0/16"
      ipv6_cidr_blocks = ""
      prefix_list_ids  = ""
      security_groups  = ""
      description      = "Allow all traffic from the VPC"
      from_port        = 0
      to_port          = 0
      protocol         = -1
    }
  ]

  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  # Subnets for the VPC
  # IP: network class, network, subnet, and device
  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  public_subnets = [
    "${var.vpc_cidr_4_ecs}.${var.public_subnets_4_ecs[0]}.0/24",
    "${var.vpc_cidr_4_ecs}.${var.public_subnets_4_ecs[1]}.0/24",
    "${var.vpc_cidr_4_ecs}.${var.public_subnets_4_ecs[2]}.0/24"
  ]
  private_subnets = [
    "${var.vpc_cidr_4_ecs}.${var.private_subnets_4_ecs[0]}.0/24",
    "${var.vpc_cidr_4_ecs}.${var.private_subnets_4_ecs[1]}.0/24",
    "${var.vpc_cidr_4_ecs}.${var.private_subnets_4_ecs[2]}.0/24"
  ]
  database_subnets = [
    "${var.vpc_cidr_4_ecs}.${var.database_subnets_4_ecs[0]}.0/24",
    "${var.vpc_cidr_4_ecs}.${var.database_subnets_4_ecs[1]}.0/24",
    "${var.vpc_cidr_4_ecs}.${var.database_subnets_4_ecs[2]}.0/24"
  ]

}

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# VPC for the EKS Cluster with 3 multiAZ public, private, and database subnets
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
module "vpc_4_ecs" {

  # TODO: Try again to name the subnets

  source = "./modules/terraform-aws-modules/terraform-aws-vpc"

  name = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}"
  cidr = "${var.vpc_cidr_4_ecs}.0.0/16"

  ### ACLs ...

  # Public Network ACL
  public_dedicated_network_acl = true # Creates a Public Network ACL
  # Default Inbound Allow from ALL - Default Outbound Deny ALL
#   public_outbound_acl_rules = concat(local.public_outbound_acl_rules["default_outbound"], local.public_outbound_acl_rules["public_outbound"])
  public_outbound_acl_rules = local.public_outbound_acl_rules["default_outbound"]

  # Private Network ACL
  private_dedicated_network_acl = false # true # Creates a Private Network ACL
  #   # Default Inbound Allow from ALL - Default Outbound Deny ALL
  #   private_outbound_acl_rules = [] #concat(local.private_outbound_acl_rules["private_outbound"], local.private_outbound_acl_rules["private_outbound"])

  # Database Network ACL
  database_dedicated_network_acl = false # true # Creates a Database Network ACL
  #   # Default Inbound Allow from ALL - Default Outbound Deny ALL
  #   database_outbound_acl_rules = [] #concat(local.database_outbound_acl_rules["database_outbound"], local.database_outbound_acl_rules["database_outbound"])

  # Default Network ACL - Association with Subnets without specific NACLs
  manage_default_network_acl = true # Allows tagging...

  # true # Always creates a Default Network ACL for all Subnets not specifically associated with a NACL
  #  default_network_acl_ingress = local.default_network_acl_ingress
  #  default_network_acl_egress  = local.default_network_acl_egress

  # Security Groups ...

  # Default Security Group is always created - No rules!
  manage_default_security_group = true # false
  default_security_group_ingress = local.default_security_group_ingress
  default_security_group_egress  = local.default_security_group_egress

  # Route Tables ...

  # Default Route Table is always created
  manage_default_route_table = true # false # If true it allows naming/tagging

  # Availability Zones ...

  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  # Subnets CIDRs ...

  public_subnets = local.public_subnets
  # Private and database subnets share the same route by default
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  # IPV6 ...

  enable_ipv6 = false

  # DNS ...

  enable_dns_hostnames = true
  enable_dns_support   = true

  # NAT Gateway ...

  enable_nat_gateway = true
  single_nat_gateway = true

  # Flow Logs ...

  enable_flow_log                           = true
  create_flow_log_cloudwatch_log_group      = true
  create_flow_log_cloudwatch_iam_role       = true
  flow_log_max_aggregation_interval         = 60
  flow_log_cloudwatch_log_group_name_prefix = "/${var.project_name}-${var.branch_name}-${local.vpc_suffix}-flow-log"
  flow_log_cloudwatch_log_group_name_suffix = "main-vpc-flow-logs"

  # Tags ...

  # subnets
  public_subnet_tags = merge({ "kubernetes.io/role/elb" = "1" }, {
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-public"
  })
  private_subnet_tags = merge({ "kubernetes.io/role/internal-elb" = "1" }, {
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-private"
  })
  database_subnet_tags = merge({ "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-db" })

  # route tables
  public_route_table_tags = { "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-public" }
  private_route_table_tags = { "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-private" }
  database_route_table_tags = { "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-db" }

  # internet gateway
  igw_tags = { "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-igw" }

  # nat gateway
  nat_gateway_tags = { "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-nat" }

  # security groups
  default_security_group_tags = {
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-default-sg"
  }

  # acls
  default_network_acl_tags = {
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-default-nacl"
  }
  public_acl_tags = {
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-public-nacl"
  }
  private_acl_tags = {
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}-private-nacl"
  }

  # vpc
  tags = merge({
    "Name" = "${var.project_name}-${var.branch_name}-${local.vpc_suffix}",
  }, local.custom_tags)
}