resource "aws_route53_record" "load_balancer" {
  for_each = toset(
    var.hosted_zone_name == null || var.alias_weighted_routing != null ?
    [] :
    [var.hosted_zone_name]
  )

  allow_overwrite = var.allow_overwrite
  name            = var.name
  type            = "A"
  zone_id         = data.aws_route53_zone.this[each.value].zone_id

  alias {
    evaluate_target_health = true
    name                   = var.alb.dns_name
    zone_id                = var.alb.zone_id
  }
}

resource "aws_route53_record" "weighted_load_balancer" {
  for_each = (
    var.hosted_zone_name == null || var.alias_weighted_routing == null ?
    {} :
    { (var.hosted_zone_name) = var.alias_weighted_routing }
  )

  allow_overwrite = var.allow_overwrite
  name            = var.name
  type            = "A"
  zone_id         = data.aws_route53_zone.this[each.key].zone_id
  set_identifier  = each.value.set_identifier

  weighted_routing_policy {
    weight = each.value.weight
  }

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
