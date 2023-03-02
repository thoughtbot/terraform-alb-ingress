variable "alb_dns_name" {
  description = "DNS name for the ALB for which an alias should be created"
  type        = string
}

variable "alb_zone_id" {
  description = "Route53 zone for the ALB for which an alias should be created"
  type        = string
}

variable "allow_overwrite" {
  type        = bool
  default     = false
  description = "Allow overwriting of existing DNS records"
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
