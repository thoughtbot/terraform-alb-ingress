variable "description" {
  description = "Human description for this load balancer"
  type        = string
}

variable "enable_access_logs" {
  type        = bool
  default     = false
  description = "Enable or disable ALB access logs. If set to true, logs will be stored in an S3 bucket."
}

variable "internal_alb" {
  description = "If true, the LB will be internal. Defaults to false"
  type        = bool
  default     = false
}
variable "name" {
  description = "Name for this load balancer"
  type        = string
}

variable "s3_logs_bucket_name" {
  type        = string
  default     = ""
  description = "Optional S3 bucket name for storing ALB access logs. If not provided, a new bucket will be created."
}

variable "namespace" {
  description = "Prefix to apply to created resources"
  type        = list(string)
  default     = []
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
