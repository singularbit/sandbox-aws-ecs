# provider "aws" {
#   region = var.region
# }
#
# # VPC
# resource "aws_vpc" "this" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags                 = var.tags
# }
#
# # Subnets
# resource "aws_subnet" "public" {
#   for_each = var.public_subnets
#
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = each.value
#   map_public_ip_on_launch = true
#   availability_zone = each.key
#
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-public-${each.key}" })
# }
#
# resource "aws_subnet" "private" {
#   for_each = var.private_subnets
#
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = each.value
#   availability_zone = each.key
#
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-private-${each.key}" })
# }
#
# # Internet Gateway
# resource "aws_internet_gateway" "this" {
#   vpc_id = aws_vpc.this.id
#
#   tags = var.tags
# }
#
# # NAT Gateway
# resource "aws_eip" "nat_eip" {
#   for_each = var.nat_gateway_enabled ? aws_subnet.public : {}
#
#   vpc = true
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-nat-${each.key}" })
# }
#
# resource "aws_nat_gateway" "this" {
#   for_each = var.nat_gateway_enabled ? aws_subnet.public : {}
#
#   allocation_id = aws_eip.nat_eip[each.key].id
#   subnet_id     = each.value.id
#
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-nat-gateway-${each.key}" })
# }
#
# # Route Tables
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.this.id
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this.id
#   }
#
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-public-rt" })
# }
#
# resource "aws_route_table_association" "public_association" {
#   for_each = aws_subnet.public
#
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.public.id
# }
#
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.this.id
#
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-private-rt" })
# }
#
# resource "aws_route_table_association" "private_association" {
#   for_each = aws_subnet.private
#
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private.id
# }
#
# resource "aws_route" "private_nat" {
#   for_each = var.nat_gateway_enabled ? aws_nat_gateway.this : {}
#
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = each.value.id
# }
#
# # Flow Logs
# resource "aws_flow_log" "vpc_flow_log" {
#   vpc_id              = aws_vpc.this.id
#   log_destination     = var.flow_log_destination
#   log_destination_type = "cloud-watch-logs"
#   traffic_type        = "ALL"
#
#   tags = var.tags
# }
#
# # Security Groups
# resource "aws_security_group" "default" {
#   vpc_id = aws_vpc.this.id
#
#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = merge(var.tags, { "Name" = "${var.name_prefix}-default-sg" })
# }