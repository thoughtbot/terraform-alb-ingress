output "dns_name" {
  description = "DNS name of the created application load balancer"
  value       = aws_alb.this.dns_name
}

output "instance" {
  description = "The created AWS application load balancer"
  value       = aws_alb.this
}

output "security_group" {
  description = "The security group created for this load balancer"
  value       = aws_security_group.this
}

output "zone_id" {
  description = "Route53 zone of the created application load balancer"
  value       = aws_alb.this.zone_id
}

