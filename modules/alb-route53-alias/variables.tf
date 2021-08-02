variable "alb" {
  description = "ALB for which an alias should be created"
  type        = object({ dns_name = string, zone_id = string })
}

variable "name" {
  description = "Name of the Route 53 alias (example: www)"
  type        = string
}

variable "hosted_zone_name" {
  type        = string
  description = "Hosted zone for AWS Route53"
  default     = null
}
