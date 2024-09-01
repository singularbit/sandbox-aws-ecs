resource "aws_alb_target_group" "alb_target_group" {
  name        = "alb-target-group" #var.alb_target_group_name
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"

  vpc_id = var.vpc_id

  health_check {
#     default             = true
    path                = var.tg_health_check_path
    protocol            = "HTTP"
    port                = 80
    interval            = 30
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = var.custom_tags
}

resource "aws_alb_listener_rule" "alb_listener_rule" {

  listener_arn = var.alb_listener_arn
  condition {
    path_pattern {
      values = ["/${var.path_pattern}/*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }


  tags = var.custom_tags
}