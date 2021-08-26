variable "enable_stickiness" {
  type        = bool
  description = "Set to true to use a cookie for load balancer stickiness"
  default     = false
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
}

variable "health_check_port" {
  description = "Port for health check"
  type        = number
}

variable "name" {
  description = "Name for this target group"
  type        = string
}

variable "target_type" {
  description = "Target group (default: ip)"
  type        = string
  default     = "ip"
}

variable "vpc_id" {
  type        = string
  description = "VPC for the target group"
}
