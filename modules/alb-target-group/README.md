<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.45 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_stickiness"></a> [enable\_stickiness](#input\_enable\_stickiness) | Set to true to use a cookie for load balancer stickiness | `bool` | `false` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Path for health check | `string` | n/a | yes |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | Port for health check | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for this target group | `string` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target group (default: ip) | `string` | `"ip"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC for the target group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | The created target group |
<!-- END_TF_DOCS -->
