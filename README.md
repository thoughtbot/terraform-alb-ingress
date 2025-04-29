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
* Support multi-account configurations
* Support externally created certificates when not using Route 53

## Example

``` terraform
module "ingress" {
  source = "git@github.com:thoughtbot/terraform-alb-ingress.git?ref=EXAMPLE"

  # Basic attributes
  description              = "My example application"
  name                     = "example-ingress"

  # Choose the domain name of the primary certificate of the HTTPS listener
  primary_certificate_domain  = "www.example.com"

  # Create and validate ACM certificates
  issue_certificate_domains = ["www.example.com", "beta.example.com"]
  validate_certificates     = true

  # Attach ACM certificates created outside the module
  attach_certificate_domains = ["example.com"]

  # Create aliases
  create_domain_aliases = ["www.example.com", "beta.example.com"]

  # Choose a Route 53 zone for aliases and certificate validation
  hosted_zone_name = "example.com"

  # Choose what should happen from CloudWatch alarms
  alarm_actions = [data.aws_sns_topic.cloudwatch_alarms]

  # Network configuration
  subnet_ids = data.aws_subnet_ids.public.ids
  vpc_id     = data.aws_vpc.example.id

  # Target group configuration
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

## Multi-account Example

The primary module can issue ACM certificates, perform Route 53 ACM certificate
validation, and create Route 53 aliases for a single hosted zone. If you have
multiple hosted zones or multiple accounts, you can combine the main module with
one or more submodules. For example, if you have `example.com` as a hosted zone
in your network account and `production.example.com` as a hosted zone in your
production account:

``` terraform
module "root_certificate" {
  source    = "github.com/thoughtbot/terraform-alb-ingress//modules/acm-certificate?ref=EXAMPLE"

  providers = {
    # AWS provider configuration for the production account. Must match the ALB.
    aws.certificate = aws.production,

    # AWS provider configuration for the network account.
    aws.route53 = aws.network
  }

  domain_name      = "example.com"
  hosted_zone_name = "example.com"
}

module "www_certificate" {
  providers = { aws.certificate = aws.production, aws.route53 = aws.network }
  source    = "github.com/thoughtbot/terraform-alb-ingress//modules/acm-certificate?ref=EXAMPLE"

  domain_name      = "www.example.com"
  hosted_zone_name = "example.com"
}

module "ingress" {
  providers = { aws.alb = aws.production, aws.route53 = aws.production }
  source    = "github.com/thoughtbot/terraform-alb-ingress?ref=EXAMPLE"

  # The domain name for the primary certificate on the HTTPS listener.
  primary_certificate_domain = "production.example.com"

  # Certificates managed by this module
  issue_certificate_domains = ["production.example.com"]

  # Externally created certificates
  attach_certificate_domains = ["example.com", "www.example.com"]

  # The name of the hosted zone where records for the ALB can be managed
  hosted_zone_name = "production.example.com"

  # Aliases which can be created in the primary hosted zone
  create_domain_aliases = ["production.example.com"]

  depends_on = [module.root_certificate, module.www_certificate]
}

module "root_alias" {
  source    = "github.com/thoughtbot/terraform-alb-ingress//modules/alb-route53-alias?ref=EXAMPLE"

  providers = {
    # AWS provider configuration for the production account. Must match the ALB.
    aws.certificate = aws.production,

    # AWS provider configuration for the network account.
    aws.route53 = aws.network
  }

  alb_dns_name     = module.ingress.alb_dns_name
  alb_zone_id      = module.ingress.alb_zone_id
  name             = "example.com"
  hosted_zone_name = "example.com"
}

module "www_alias" {
  providers = { aws.certificate = aws.production, aws.route53 = aws.network }
  source    = "github.com/thoughtbot/terraform-alb-ingress//modules/alb-route53-alias?ref=EXAMPLE"

  alb_dns_name     = module.ingress.alb_dns_name
  alb_zone_id      = module.ingress.alb_zone_id
  name             = "www.example.com"
  hosted_zone_name = "example.com"
}
```

## Non-Route 53 Example

If you aren't using Route 53 as a DNS provider, you can issue certificates on
your own and disable creation of aliases.

``` terraform
module "ingress" {
  providers = { aws.alb = aws, aws.route53 = aws }
  source    = "github.com/thoughtbot/terraform-alb-ingress?ref=EXAMPLE"

  # The domain name for the primary certificate on the HTTPS listener.
  primary_certificate_domain = "example.com"

  # Don't issue any certificates
  issue_certificate_domains = []

  # Externally created certificates
  attach_certificate_domains = ["example.com", "www.example.com"]

  # Don't create aliases
  create_domain_aliases = ["production.example.com"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

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
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | Allow overwriting of existing DNS records | `bool` | `false` | no |
| <a name="input_attach_certificate_domains"></a> [attach\_certificate\_domains](#input\_attach\_certificate\_domains) | Additional existing certificates which should be attached | `list(string)` | `[]` | no |
| <a name="input_certificate_types"></a> [certificate\_types](#input\_certificate\_types) | Types of certificates to look for (default: AMAZON\_ISSUED) | `list(string)` | <pre>[<br>  "AMAZON_ISSUED"<br>]</pre> | no |
| <a name="input_create_domain_aliases"></a> [create\_domain\_aliases](#input\_create\_domain\_aliases) | List of domains for which alias records should be created | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Human description for this load balancer | `string` | n/a | yes |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Enable or disable ALB access logs. If set to true, logs will be stored in an S3 bucket. | `bool` | `false` | no |
| <a name="input_enable_stickiness"></a> [enable\_stickiness](#input\_enable\_stickiness) | Set to true to use a cookie for load balancer stickiness | `bool` | `false` | no |
| <a name="input_failure_threshold"></a> [failure\_threshold](#input\_failure\_threshold) | Percentage of failed requests considered an anomaly | `number` | `5` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Hosted zone for AWS Route53 | `string` | `null` | no |
| <a name="input_issue_certificate_domains"></a> [issue\_certificate\_domains](#input\_issue\_certificate\_domains) | List of domains for which certificates should be issued | `list(string)` | `[]` | no |
| <a name="input_legacy_target_group_names"></a> [legacy\_target\_group\_names](#input\_legacy\_target\_group\_names) | Names of legacy target groups which should be included | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this load balancer | `string` | n/a | yes |
| <a name="input_primary_certificate_domain"></a> [primary\_certificate\_domain](#input\_primary\_certificate\_domain) | Primary domain name for the load balancer certificate | `string` | n/a | yes |
| <a name="input_s3_logs_bucket_name"></a> [s3\_logs\_bucket\_name](#input\_s3\_logs\_bucket\_name) | Optional S3 bucket name for storing ALB access logs. If not provided, a new bucket will be created. | `string` | `""` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name for the load balancer security group; defaults to name | `string` | `null` | no |
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
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the created application load balancer |
| <a name="output_http_listener"></a> [http\_listener](#output\_http\_listener) | The HTTP listener |
| <a name="output_https_listener"></a> [https\_listener](#output\_https\_listener) | The HTTPS listener |
| <a name="output_instance"></a> [instance](#output\_instance) | The load balancer |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Security group for the load balancer |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Route53 zone of the created application load balancer |
<!-- END_TF_DOCS -->
