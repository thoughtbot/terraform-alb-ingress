variable "alarm_actions" {
  type        = list(object({ arn = string }))
  description = "SNS topics or other actions to invoke for alarms"
  default     = []
}

variable "alarm_evaluation_minutes" {
  type        = number
  default     = 2
  description = "Number of minutes of alarm state until triggering an alarm"
}

variable "alternative_domain_names" {
  type        = list(string)
  default     = []
  description = "Alternative domain names for the ALB"
}

variable "create_aliases" {
  description = "Set to false to disable creation of Route 53 aliases"
  type        = bool
  default     = true
}

variable "description" {
  description = "Human description for this load balancer"
  type        = string
}

variable "enable_stickiness" {
  type        = bool
  description = "Set to true to use a cookie for load balancer stickiness"
  default     = false
}

variable "failure_threshold" {
  type        = number
  description = "Percentage of failed requests considered an anomaly"
  default     = 5
}

variable "hosted_zone_name" {
  type        = string
  description = "Hosted zone for AWS Route53"
  default     = null
}

variable "issue_certificates" {
  description = "Set to false to disable creation of ACM certificates"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name for this load balancer"
  type        = string
}

variable "namespace" {
  description = "Prefix to apply to created resources"
  type        = list(string)
  default     = []
}

variable "primary_domain_name" {
  type        = string
  description = "Primary domain name for the ALB"
}

variable "slow_response_threshold" {
  type        = number
  default     = 10
  description = "Response time considered extremely slow"
}

variable "subnets" {
  type        = map(object({ id = string }))
  description = "Subnets for this load balancer"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}

variable "target_groups" {
  description = "Target groups to which this rule should forward"

  type = map(object({
    health_check_path = string,
    health_check_port = number,
    name              = string
  }))
}

variable "target_group_weights" {
  description = "Weight for each target group (defaults to 100)"
  type        = map(number)
  default     = {}
}

variable "validate_certificates" {
  description = "Set to false to disable validation via Route 53"
  type        = bool
  default     = true
}

variable "vpc" {
  type        = object({ id = string })
  description = "VPC for the ALB"
}
