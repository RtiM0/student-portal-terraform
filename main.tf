terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

}

provider "aws" {
  region = var.region
}

resource "random_pet" "name" {
  length = 2
}

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name = "students-table-${random_pet.name.id}"
}

module "cognito-userpool" {
  source = "./modules/cognito-userpool"

  userpool_name = "student-portal-${random_pet.name.id}"
}

module "iam-role" {
  source = "./modules/iam"

  iam_role_name   = "student-portal-api-${random_pet.name.id}"
  iam_policy_name = "student-portal-api-${random_pet.name.id}-policy"
  cognito_arn     = module.cognito-userpool.cognito_arn
  dynamo_arn      = module.dynamodb.dynamo_arn
}

module "lambda" {
  source = "./modules/lambda"

  iam_arn       = module.iam-role.iam_arn
  bucket_name   = random_pet.name.id
  function_name = random_pet.name.id
  userpool_id   = module.cognito-userpool.userpool_id
  table_name    = "students-table-${random_pet.name.id}"
}

module "api-gateway" {
  source = "./modules/api-gateway"

  lambda_function_name = random_pet.name.id
  lambda_invoke_arn    = module.lambda.invoke_arn
  api_name             = "student-portal-api-${random_pet.name.id}"
  userpool_id          = module.cognito-userpool.userpool_id
  userpool_client_id   = module.cognito-userpool.userpool_client_id
  userpool_region      = var.region
}

module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_name = "student-portal-${random_pet.name.id}"
}

module "codebuild" {
  source = "./modules/codebuild"

  codebuild_name = "${random_pet.name.id}-build"
  source_repo    = var.frontend_repo_path
}

module "codepipeline" {
  source = "./modules/codepipeline"

  pipeline_name       = "${random_pet.name.id}-pipeline"
  source_repo         = var.frontend_repo_path
  userpool_id         = module.cognito-userpool.userpool_id
  userpool_client_id  = module.cognito-userpool.userpool_client_id
  api_endpoint        = module.api-gateway.base_url
  production_endpoint = module.cloudfront.cloudfront_url
  region              = var.region
  source_bucket_name  = "student-portal-${random_pet.name.id}"
  source_bucket_arn   = module.cloudfront.bucket_arn
  source_repo_branch  = var.frontend_repo_branch
  codebuild_name      = "${random_pet.name.id}-build"
}
