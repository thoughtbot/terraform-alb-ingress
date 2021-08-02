variable "alternative_names" {
  type        = list(string)
  description = "Other domains which should be included in the certificate"
  default     = []
}

variable "domain_name" {
  type        = string
  description = "Domain for which an SSL certificate should be created"
}

variable "hosted_zone_name" {
  type        = string
  description = "Zone for AWS Route53 for verifying certificates"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "validation_method" {
  type        = string
  description = "DNS or EMAIL; defaults to DNS"
  default     = "DNS"
}

variable "wildcard" {
  type        = bool
  description = "If true, a wildcard certificate will be provisioned"
  default     = false
}
