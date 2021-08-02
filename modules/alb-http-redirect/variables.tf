variable "alb" {
  description = "The ALB for which a listener should be created"
  type        = object({ arn = string })
}
