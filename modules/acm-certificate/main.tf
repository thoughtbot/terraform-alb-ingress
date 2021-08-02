resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  tags              = var.tags
  validation_method = var.validation_method

  subject_alternative_names = concat(
    var.wildcard ? ["*.${var.domain_name}"] : [],
    var.alternative_names
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  domain_validation_options = tolist(aws_acm_certificate.this.domain_validation_options)
}

resource "aws_route53_record" "validation" {
  count = var.hosted_zone_name == null ? 0 : 1

  name    = local.domain_validation_options[0].resource_record_name
  records = [local.domain_validation_options[0].resource_record_value]
  ttl     = 3600
  type    = local.domain_validation_options[0].resource_record_type
  zone_id = join("", data.aws_route53_zone.this.*.zone_id)
}

resource "aws_route53_record" "alternative_validation" {
  count = var.hosted_zone_name == null ? 0 : length(var.alternative_names)

  name    = local.domain_validation_options[count.index].resource_record_name
  records = [local.domain_validation_options[count.index].resource_record_value]
  ttl     = 3600
  type    = local.domain_validation_options[count.index].resource_record_type
  zone_id = join("", data.aws_route53_zone.this.*.zone_id)
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = concat(
    aws_route53_record.validation.*.fqdn,
    aws_route53_record.alternative_validation.*.fqdn
  )
}

data "aws_route53_zone" "this" {
  count = var.hosted_zone_name == null ? 0 : 1

  name = var.hosted_zone_name
}
