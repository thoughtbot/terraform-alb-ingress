variable "description" {
  description = "Human description for this load balancer"
  type        = string
}

variable "name" {
  description = "Name for this load balancer"
  type        = string
}

variable "security_group_name" {
  type        = string
  description = "Name for the load balancer security group; defaults to name"
  default     = null
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

variable "vpc_id" {
  type        = string
  description = "VPC for the ALB"
}
