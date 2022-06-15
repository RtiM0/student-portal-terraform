output "invoke_arn" {
  value       = aws_lambda_function.student_portal_api.invoke_arn
  description = "Lambda Function's Invoke ARN"
}
