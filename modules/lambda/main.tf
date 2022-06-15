resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_file" {
  type = "zip"

  source_dir  = "${path.module}/student-portal-api"
  output_path = "${path.module}/output/student-portal-api.zip"
}

resource "aws_s3_object" "lambda_student_portal" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "student-portal-api.zip"
  source = data.archive_file.lambda_file.output_path

  etag = filemd5(data.archive_file.lambda_file.output_path)
}

resource "aws_lambda_function" "student_portal_api" {
  function_name = var.function_name

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_student_portal.key

  runtime = "nodejs14.x"
  handler = "handler.handler"

  source_code_hash = data.archive_file.lambda_file.output_base64sha256
  role             = var.iam_arn

  environment {
    variables = {
      "USERPOOL_ID"    = var.userpool_id,
      "STUDENTS_TABLE" = var.table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "student_portal_api" {
  name = "/aws/lambda/${aws_lambda_function.student_portal_api.function_name}"

  retention_in_days = 30
}
