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
| [aws_cloudwatch_metric_alarm.error_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.failure_ratio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.response_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | SNS topics or other actions to invoke for alarms | `list(object({ arn = string }))` | `[]` | no |
| <a name="input_alarm_evaluation_minutes"></a> [alarm\_evaluation\_minutes](#input\_alarm\_evaluation\_minutes) | Number of minutes of alarm state until triggering an alarm | `number` | `2` | no |
| <a name="input_alb"></a> [alb](#input\_alb) | The ALB for which alarms should be created | `object({ name = string, arn_suffix = string })` | n/a | yes |
| <a name="input_failure_threshold"></a> [failure\_threshold](#input\_failure\_threshold) | Percentage of failed requests considered an anomaly | `number` | `5` | no |
| <a name="input_slow_response_threshold"></a> [slow\_response\_threshold](#input\_slow\_response\_threshold) | Response time considered extremely slow | `number` | `10` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Target groups for which alarms should be created | `map(object({ name = string, arn_suffix = string }))` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
