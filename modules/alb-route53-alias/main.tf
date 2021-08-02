resource "aws_route53_record" "load_balancer" {
  for_each = toset(var.hosted_zone_name == null ? [] : [var.hosted_zone_name])

  zone_id = data.aws_route53_zone.this[each.value].zone_id
  type    = "A"
  name    = var.name

  alias {
    evaluate_target_health = true
    name                   = var.alb.dns_name
    zone_id                = var.alb.zone_id
  }
}

data "aws_route53_zone" "this" {
  for_each = toset(var.hosted_zone_name == null ? [] : [var.hosted_zone_name])

  name = each.value
}
