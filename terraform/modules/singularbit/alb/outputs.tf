output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "aws_alb_arn" {
  value = aws_alb.aws_alb.arn
}

output "aws_alb_id" {
  value = aws_alb.aws_alb.id
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

# output "alb_listener_arn" {
#   value = aws_alb_listener.alb_listener.arn
# }

output "aws_alb_dns_name" {
  value = aws_alb.aws_alb.dns_name
}
output "aws_alb_suffix" {
  value = aws_alb.aws_alb.arn_suffix
}

