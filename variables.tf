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

variable "allow_overwrite" {
  type        = bool
  default     = false
  description = "Allow overwriting of existing DNS records"
}

variable "attach_certificate_domains" {
  description = "Additional existing certificates which should be attached"
  type        = list(string)
  default     = []
}

variable "certificate_types" {
  type        = list(string)
  description = "Types of certificates to look for (default: AMAZON_ISSUED)"
  default     = ["AMAZON_ISSUED"]
}

variable "create_domain_aliases" {
  description = "List of domains for which alias records should be created"
  type        = list(string)
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

variable "issue_certificate_domains" {
  description = "List of domains for which certificates should be issued"
  type        = list(string)
  default     = []
}

variable "legacy_target_group_names" {
  description = "Names of legacy target groups which should be included"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Name for this load balancer"
  type        = string
}

variable "primary_certificate_domain" {
  description = "Primary domain name for the load balancer certificate"
  type        = string
}

variable "security_group_name" {
  type        = string
  description = "Name for the load balancer security group; defaults to name"
  default     = null
}

variable "slow_response_threshold" {
  type        = number
  default     = 10
  description = "Response time considered extremely slow"
}

variable "subnet_ids" {
  type        = list(string)
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

variable "vpc_id" {
  type        = string
  description = "VPC for the ALB"
}
