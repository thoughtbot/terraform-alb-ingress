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

variable "alb" {
  description = "The ALB for which alarms should be created"
  type        = object({ name = string, arn_suffix = string })
}

variable "failure_threshold" {
  type        = number
  description = "Percentage of failed requests considered an anomaly"
  default     = 5
}

variable "slow_response_threshold" {
  type        = number
  default     = 10
  description = "Response time considered extremely slow"
}

variable "target_groups" {
  description = "Target groups for which alarms should be created"
  type        = map(object({ name = string, arn_suffix = string }))
}
