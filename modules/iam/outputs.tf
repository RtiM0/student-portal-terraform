output "iam_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "IAM Role's ARN"
}
