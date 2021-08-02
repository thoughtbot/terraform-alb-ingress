output "certificate" {
  value       = { arn = aws_acm_certificate_validation.this.certificate_arn }
  description = "Certificate managed by ACM"
}

output "name" {
  value       = aws_acm_certificate.this.domain_name
  description = "Domain name for the certificate"
}
