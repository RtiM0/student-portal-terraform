output "dynamo_arn" {
  value       = aws_dynamodb_table.studentstable.arn
  description = "DynamoDB Table's ARN"
}
