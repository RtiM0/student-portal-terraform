variable "iam_arn" {
  description = "IAM Role's ARN"
}

variable "bucket_name" {
  description = "Name of Lambda's S3 Bucket"
}

variable "function_name" {
  description = "Lambda function name"
}

variable "userpool_id" {
  description = "Cognito UserPool ID"
}

variable "table_name" {
  description = "DynamoDB Table Name"
}
