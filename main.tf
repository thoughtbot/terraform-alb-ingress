module "alb" {
  providers = { aws = aws.cluster }
  source    = "./modules/alb"

  description         = var.description
  name                = var.name
  enable_access_logs  = var.enable_access_logs
  s3_logs_bucket_name = var.s3_logs_bucket_name

  namespace  = var.namespace
  subnet_ids = var.subnet_ids
  tags       = var.tags
  vpc_id     = var.vpc_id
}

module "cloudwatch_alarms" {
  providers = { aws = aws.cluster }
  source    = "./modules/alb-cloudwatch-alarms"

  alarm_actions            = var.alarm_actions
  alarm_evaluation_minutes = var.alarm_evaluation_minutes
  alb                      = module.alb.instance
  failure_threshold        = var.failure_threshold
  slow_response_threshold  = var.slow_response_threshold
  target_groups            = local.target_groups
}

module "http" {
  providers = { aws = aws.cluster }
  source    = "./modules/alb-http-redirect"

  alb = module.alb.instance
}

module "https" {
  providers = { aws = aws.cluster }
  source    = "./modules/alb-https-forward"

  alb                      = module.alb.instance
  alternative_domain_names = var.alternative_domain_names
  certificate_domain_name  = local.certificate_domain_name
  certificate_types        = var.certificate_types
  target_groups            = local.target_groups
  target_group_weights     = var.target_group_weights

  depends_on = [module.acm_certificate]
}

module "acm_certificate" {
  for_each  = toset(var.issue_certificates ? local.domain_names : [])
  providers = { aws.certificate = aws.cluster, aws.route53 = aws.route53 }
  source    = "./modules/acm-certificate"

  allow_overwrite = var.allow_overwrite
  domain_name     = each.value

  hosted_zone_name = (
    var.validate_certificates ?
    try(var.additional_hosted_zones[each.value], var.hosted_zone_name) :
    null
  )
}

module "alias" {
  for_each  = toset(var.create_aliases ? local.domain_names : [])
  providers = { aws = aws.route53 }
  source    = "./modules/alb-route53-alias"

  alb             = module.alb.instance
  allow_overwrite = var.allow_overwrite
  name            = each.value

  hosted_zone_name = try(
    var.additional_hosted_zones[each.value],
    var.hosted_zone_name
  )
}

module "target_group" {
  for_each  = var.target_groups
  providers = { aws = aws.cluster }
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
  certificate_domain_name = coalesce(
    var.certificate_domain_name,
    var.primary_domain_name
  )

  domain_names = concat([var.primary_domain_name], var.alternative_domain_names)

  target_groups = zipmap(
    concat(keys(var.target_groups), keys(data.aws_lb_target_group.legacy)),
    concat(
      values(module.target_group).*.instance,
      values(data.aws_lb_target_group.legacy)
    )
  )
}
