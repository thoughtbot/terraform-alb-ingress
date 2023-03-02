output "dns_name" {
  description = "DNS name of the created application load balancer"
  value       = module.alb.dns_name
}

output "instance" {
  description = "The load balancer"
  value       = module.alb.instance
}

output "security_group" {
  description = "Security group for the load balancer"
  value       = module.alb.security_group
}

output "http_listener" {
  description = "The HTTP listener"
  value       = module.http.instance
}

output "https_listener" {
  description = "The HTTPS listener"
  value       = module.https.instance
}

output "zone_id" {
  description = "Route53 zone of the created application load balancer"
  value       = module.alb.zone_id
}
