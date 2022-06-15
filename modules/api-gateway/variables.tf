variable "api_name" {
  description = "Name of the API"
}

variable "lambda_function_name" {
  description = "Name of Lambda Function"
}

variable "lambda_invoke_arn" {
  description = "Lambda Function's Invoke ARN"
}

variable "userpool_id" {
  description = "Cognito UserPool ID for JWT Authorizer"
}

variable "userpool_client_id" {
  description = "Cognito UserPool Client ID for JWT Authorizer"
}

variable "userpool_region" {
  description = "Cognito UserPool Region"
}
