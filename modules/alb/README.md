<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_s3_bucket.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.aws_alb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aws_alb_http_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aws_alb_https_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Human description for this load balancer | `string` | n/a | yes |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Enable or disable ALB access logs. If set to true, logs will be stored in an S3 bucket. | `bool` | `false` | no |
| <a name="input_enable_connection_logs"></a> [enable\_connection\_logs](#input\_enable\_connection\_logs) | Enable or disable ALB connection logs. If set to true, logs will be stored in an S3 bucket. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this load balancer | `string` | n/a | yes |
| <a name="input_s3_logs_bucket_name"></a> [s3\_logs\_bucket\_name](#input\_s3\_logs\_bucket\_name) | Optional S3 bucket name for storing ALB access logs. If not provided, a new bucket will be created. | `string` | `""` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name for the load balancer security group; defaults to name | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets for this load balancer | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to created resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC for the ALB | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the created application load balancer |
| <a name="output_instance"></a> [instance](#output\_instance) | The created AWS application load balancer |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group created for this load balancer |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Route53 zone of the created application load balancer |
<!-- END_TF_DOCS -->
