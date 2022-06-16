variable "pipeline_name" {
  description = "Name of Pipeline"
}

variable "source_repo" {
  description = "Frontend Repo Path"
}

variable "source_repo_branch" {
  description = "Frontend Repo Branch"
}

variable "userpool_id" {
  description = "Cognito UserPool ID"
}

variable "userpool_client_id" {
  description = "Cognito UserPool Client ID"
}

variable "api_endpoint" {
  description = "Endpoint of API"
}

variable "region" {
  description = "AWS Region of destination bucket"
}

variable "production_endpoint" {
  description = "Endpoint of production"
}

variable "source_bucket_name" {
  description = "Destination Bucket Name"
}

variable "source_bucket_arn" {
  description = "Destination Bucket ARN"
}

variable "codebuild_name" {
  description = "Name of the CodeBuild project"
}
