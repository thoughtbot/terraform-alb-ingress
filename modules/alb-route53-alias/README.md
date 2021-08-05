<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | ALB for which an alias should be created | `object({ dns_name = string, zone_id = string })` | n/a | yes |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Hosted zone for AWS Route53 | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Route 53 alias (example: www) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
