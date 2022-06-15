output "API" {
  value       = module.api-gateway.base_url
  description = "Base URL of the API"
}

output "Frontend" {
  value       = module.cloudfront.cloudfront_url
  description = "Base URL of the Frontend"
}
