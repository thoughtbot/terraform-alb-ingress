output "instance" {
  description = "The created AWS application load balancer"
  value       = aws_alb.this
}

output "security_group" {
  description = "The security group created for this load balancer"
  value       = aws_security_group.this
}
