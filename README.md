# Terraform ALB Ingress

Provisions an ingress stack using an AWS Application Load Balancer suitable for
deployments to EKS or ECS.

Major features:

* Create an AWS ALB with a dedicated security group
* Create an HTTP listener to redirect plaintext traffic to HTTPS
* Create an HTTPS listener to forward traffic to one or more target groups
* Create Route 53 aliases for public traffic
* Create ACM certificates for SSL
* Validate ACM certificates using Route 53
* Create sensible Cloudwatch alarms for monitoring traffic

## Example

``` terraform
module "ingress" {
  source = "git@github.com:thoughtbot/terraform-alb-ingress.git?ref=v0.1.0"

  alarm_actions            = [data.aws_sns_topic.cloudwatch_alarms]
  alternate_domain_names   = ["example.com", "api.example.com"]
  description              = "My example application"
  hosted_zone_name         = "example.com"
  name                     = "example-ingress"
  primary_domain_name      = "www.example.com"
  subnet_ids               = data.aws_subnet_ids.public.ids
  vpc_id                   = data.aws_vpc.example.id

  target_groups = {
    canary = {
      health_check_path = "/healthz"
      health_check_port = "8080"
      name              = "canary"
    }
    stable = {
      health_check_path = "/healthz"
      health_check_port = "8080"
      name              = "stable"
    }
  }

  target_group_weights = {
    canary = 5
    stable = 95
  }
}
```

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_certificate"></a> [acm\_certificate](#module\_acm\_certificate) | ./modules/acm-certificate | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_alias"></a> [alias](#module\_alias) | ./modules/alb-route53-alias | n/a |
| <a name="module_cloudwatch_alarms"></a> [cloudwatch\_alarms](#module\_cloudwatch\_alarms) | ./modules/alb-cloudwatch-alarms | n/a |
| <a name="module_http"></a> [http](#module\_http) | ./modules/alb-http-redirect | n/a |
| <a name="module_https"></a> [https](#module\_https) | ./modules/alb-https-forward | n/a |
| <a name="module_target_group"></a> [target\_group](#module\_target\_group) | ./modules/alb-target-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb_target_group.legacy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | SNS topics or other actions to invoke for alarms | `list(object({ arn = string }))` | `[]` | no |
| <a name="input_alarm_evaluation_minutes"></a> [alarm\_evaluation\_minutes](#input\_alarm\_evaluation\_minutes) | Number of minutes of alarm state until triggering an alarm | `number` | `2` | no |
| <a name="input_alternative_domain_names"></a> [alternative\_domain\_names](#input\_alternative\_domain\_names) | Alternative domain names for the ALB | `list(string)` | `[]` | no |
| <a name="input_certificate_domain_name"></a> [certificate\_domain\_name](#input\_certificate\_domain\_name) | Override the domain name for the ACM certificate (defaults to primary domain) | `string` | `null` | no |
| <a name="input_create_aliases"></a> [create\_aliases](#input\_create\_aliases) | Set to false to disable creation of Route 53 aliases | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Human description for this load balancer | `string` | n/a | yes |
| <a name="input_enable_stickiness"></a> [enable\_stickiness](#input\_enable\_stickiness) | Set to true to use a cookie for load balancer stickiness | `bool` | `false` | no |
| <a name="input_failure_threshold"></a> [failure\_threshold](#input\_failure\_threshold) | Percentage of failed requests considered an anomaly | `number` | `5` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Hosted zone for AWS Route53 | `string` | `null` | no |
| <a name="input_issue_certificates"></a> [issue\_certificates](#input\_issue\_certificates) | Set to false to disable creation of ACM certificates | `bool` | `true` | no |
| <a name="input_legacy_target_group_names"></a> [legacy\_target\_group\_names](#input\_legacy\_target\_group\_names) | Names of legacy target groups which should be included | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this load balancer | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to apply to created resources | `list(string)` | `[]` | no |
| <a name="input_primary_domain_name"></a> [primary\_domain\_name](#input\_primary\_domain\_name) | Primary domain name for the ALB | `string` | n/a | yes |
| <a name="input_slow_response_threshold"></a> [slow\_response\_threshold](#input\_slow\_response\_threshold) | Response time considered extremely slow | `number` | `10` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets for this load balancer | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to created resources | `map(string)` | `{}` | no |
| <a name="input_target_group_weights"></a> [target\_group\_weights](#input\_target\_group\_weights) | Weight for each target group (defaults to 100) | `map(number)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Target groups to which this rule should forward | <pre>map(object({<br>    health_check_path = string,<br>    health_check_port = number,<br>    name              = string<br>  }))</pre> | n/a | yes |
| <a name="input_validate_certificates"></a> [validate\_certificates](#input\_validate\_certificates) | Set to false to disable validation via Route 53 | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC for the ALB | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_http_listener"></a> [http\_listener](#output\_http\_listener) | The HTTP listener |
| <a name="output_https_listener"></a> [https\_listener](#output\_https\_listener) | The HTTPS listener |
| <a name="output_instance"></a> [instance](#output\_instance) | The load balancer |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Security group for the load balancer |
<!-- END_TF_DOCS -->
