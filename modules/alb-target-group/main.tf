resource "aws_alb_target_group" "this" {
  name        = var.name
  port        = 443
  protocol    = "HTTPS"
  target_type = var.target_type
  vpc_id      = var.vpc.id

  health_check {
    path = var.health_check_path
    port = var.health_check_port
  }

  stickiness {
    type    = "lb_cookie"
    enabled = var.enable_stickiness
  }
}
