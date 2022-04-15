resource "aws_alb_listener" "this" {
  certificate_arn   = data.aws_acm_certificate.acm_certificate.arn
  load_balancer_arn = var.alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type = "forward"

    # Terraform requires this parameter only when there is a single target group
    target_group_arn = (
      length(var.target_groups) == 1 ?
      values(var.target_groups)[0].arn :
      null
    )

    # Terraform reports a perpetual diff with both foward and target_group_arn
    dynamic "forward" {
      for_each = length(var.target_groups) == 1 ? [] : [true]

      content {
        stickiness {
          duration = 60
          enabled  = false
        }

        dynamic "target_group" {
          for_each = var.target_groups

          content {
            arn    = target_group.value.arn
            weight = lookup(var.target_group_weights, target_group.key, 100)
          }
        }
      }
    }
  }
}

resource "aws_alb_listener_certificate" "this" {
  for_each = data.aws_acm_certificate.alternatives

  certificate_arn = each.value.arn
  listener_arn    = aws_alb_listener.this.arn
}

data "aws_acm_certificate" "acm_certificate" {
  domain      = var.certificate_domain_name
  most_recent = true
  statuses    = ["ISSUED"]
}

data "aws_acm_certificate" "alternatives" {
  for_each = toset(var.alternative_domain_names)

  domain      = each.value
  most_recent = true
  statuses    = ["ISSUED"]
}
