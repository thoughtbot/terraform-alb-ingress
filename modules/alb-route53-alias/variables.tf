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

variable "alias_weighted_routing" {
  description = "Optional weighted routing configuration for the Route 53 alias"
  type = object({
    weight         = number
    set_identifier = string
  })
  default = null

  validation {
    condition     = try(var.alias_weighted_routing.weight >= 0, true)
    error_message = "alias_weighted_routing.weight must be greater than or equal to 0."
  }

  validation {
    condition     = try(trimspace(var.alias_weighted_routing.set_identifier) != "", true)
    error_message = "alias_weighted_routing.set_identifier must not be empty."
  }
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
