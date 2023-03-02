module "alb" {
  providers = { aws = aws.alb }
  source    = "./modules/alb"

  description         = var.description
  name                = var.name
  security_group_name = var.security_group_name
  subnet_ids          = var.subnet_ids
  tags                = var.tags
  vpc_id              = var.vpc_id
}

module "cloudwatch_alarms" {
  providers = { aws = aws.alb }
  source    = "./modules/alb-cloudwatch-alarms"

  alarm_actions            = var.alarm_actions
  alarm_evaluation_minutes = var.alarm_evaluation_minutes
  alb                      = module.alb.instance
  failure_threshold        = var.failure_threshold
  slow_response_threshold  = var.slow_response_threshold
  target_groups            = local.target_groups
}

module "http" {
  providers = { aws = aws.alb }
  source    = "./modules/alb-http-redirect"

  alb = module.alb.instance
}

module "https" {
  providers = { aws = aws.alb }
  source    = "./modules/alb-https-forward"

  alb                      = module.alb.instance
  alternative_domain_names = local.alternative_certificate_domains
  certificate_domain_name  = var.primary_certificate_domain
  certificate_types        = var.certificate_types
  target_groups            = local.target_groups
  target_group_weights     = var.target_group_weights

  depends_on = [module.acm_certificate]
}

module "acm_certificate" {
  for_each  = toset(var.issue_certificate_domains)
  providers = { aws.certificate = aws.alb, aws.route53 = aws.route53 }
  source    = "./modules/acm-certificate"

  allow_overwrite  = var.allow_overwrite
  domain_name      = each.value
  hosted_zone_name = var.validate_certificates ? var.hosted_zone_name : null
}

module "alias" {
  for_each  = toset(var.create_domain_aliases)
  providers = { aws = aws.route53 }
  source    = "./modules/alb-route53-alias"

  alb_dns_name     = module.alb.dns_name
  alb_zone_id      = module.alb.zone_id
  allow_overwrite  = var.allow_overwrite
  hosted_zone_name = var.hosted_zone_name
  name             = each.value
}

module "target_group" {
  for_each  = var.target_groups
  providers = { aws = aws.alb }
  source    = "./modules/alb-target-group"

  enable_stickiness = var.enable_stickiness
  health_check_path = each.value.health_check_path
  health_check_port = each.value.health_check_port
  name              = each.value.name
  vpc_id            = var.vpc_id
}

data "aws_lb_target_group" "legacy" {
  for_each = toset(var.legacy_target_group_names)

  name = each.value
}

locals {
  certificate_domains = toset(concat(
    [var.primary_certificate_domain],
    var.issue_certificate_domains,
    var.attach_certificate_domains
  ))

  alternative_certificate_domains = setsubtract(
    local.certificate_domains,
    [var.primary_certificate_domain]
  )

  target_groups = zipmap(
    concat(keys(var.target_groups), keys(data.aws_lb_target_group.legacy)),
    concat(
      values(module.target_group).*.instance,
      values(data.aws_lb_target_group.legacy)
    )
  )
}
