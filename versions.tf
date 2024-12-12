terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      configuration_aliases = [aws.alb, aws.route53]
      source                = "hashicorp/aws"
      version               = "~> 5.0"
    }
  }
}
