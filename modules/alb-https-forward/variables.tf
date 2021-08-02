variable "alb" {
  description = "The ALB for which a listener should be created"
  type        = object({ arn = string })
}

variable "alternative_domain_names" {
  type        = list(string)
  default     = []
  description = "Alternative domain names for the ALB"
}

variable "primary_domain_name" {
  type        = string
  description = "Primary domain name for the ALB"
}

variable "target_groups" {
  description = "The target groups to which this listener should forward"
  type        = map(object({ arn = string }))
}

variable "target_group_weights" {
  description = "Weight for each target group (defaults to 100)"
  type        = map(number)
  default     = {}
}
