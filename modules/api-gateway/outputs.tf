output "base_url" {
  value       = aws_apigatewayv2_stage.lambda.invoke_url
  description = "Base URL of API"
}
