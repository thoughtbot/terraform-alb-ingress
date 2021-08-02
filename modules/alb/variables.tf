variable "description" {
  description = "Human description for this load balancer"
  type        = string
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

variable "subnets" {
  type        = map(object({ id = string }))
  description = "Subnets for this load balancer"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}

variable "vpc" {
  type        = object({ id = string })
  description = "VPC for the ALB"
}
