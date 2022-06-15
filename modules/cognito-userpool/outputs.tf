output "userpool_id" {
  description = "Cognito UserPool ID"
  value       = aws_cognito_user_pool.pool.id
}

output "userpool_client_id" {
  description = "Cognito UserPool Client ID"
  value       = aws_cognito_user_pool_client.react.id
}

output "cognito_arn" {
  description = "Cognito UserPool's ARN"
  value       = aws_cognito_user_pool.pool.arn
}
