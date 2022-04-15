resource "aws_acm_certificate" "this" {
  provider = aws.certificate

  domain_name       = var.domain_name
  tags              = var.tags
  validation_method = var.validation_method

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

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
  provider = aws.route53

  count = var.hosted_zone_name == null ? 0 : 1

  allow_overwrite = var.allow_overwrite
  name            = local.domain_validation_options[0].resource_record_name
  records         = [local.domain_validation_options[0].resource_record_value]
  ttl             = 3600
  type            = local.domain_validation_options[0].resource_record_type
  zone_id         = join("", data.aws_route53_zone.this.*.zone_id)
}

resource "aws_route53_record" "alternative_validation" {
  provider = aws.route53

  count = var.hosted_zone_name == null ? 0 : length(var.alternative_names)

  allow_overwrite = var.allow_overwrite
  name            = local.domain_validation_options[count.index].resource_record_name
  records         = [local.domain_validation_options[count.index].resource_record_value]
  ttl             = 3600
  type            = local.domain_validation_options[count.index].resource_record_type
  zone_id         = join("", data.aws_route53_zone.this.*.zone_id)
}

resource "aws_acm_certificate_validation" "this" {
  provider = aws.certificate

  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = concat(
    aws_route53_record.validation.*.fqdn,
    aws_route53_record.alternative_validation.*.fqdn
  )
}

data "aws_route53_zone" "this" {
  provider = aws.route53

  count = var.hosted_zone_name == null ? 0 : 1

  name = var.hosted_zone_name
}
