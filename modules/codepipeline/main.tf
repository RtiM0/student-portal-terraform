resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.connection.arn
        FullRepositoryId = var.source_repo
        BranchName       = var.source_repo_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        "ProjectName" = var.codebuild_name
        "EnvironmentVariables" = jsonencode([
          {
            "name" : "REACT_APP_USERPOOLID",
            "value" : var.userpool_id
          },
          {
            "name" : "REACT_APP_CLIENTID",
            "value" : var.userpool_client_id
          },
          {
            "name" : "REACT_APP_API_ENDPOINT",
            "value" : var.api_endpoint
          },
          {
            "name" : "REACT_APP_REGION",
            "value" : var.region
          },
          {
            "name" : "REACT_APP_PRODUCTION_ENDPOINT",
            "value" : var.production_endpoint
          },
        ])
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = 1
      input_artifacts = ["build_output"]
      region          = var.region

      configuration = {
        "BucketName" = var.source_bucket_name
        "Extract"    = true
      }
    }
  }
}

resource "aws_codestarconnections_connection" "connection" {
  name          = "${var.pipeline_name}-github"
  provider_type = "GitHub"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.pipeline_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.pipeline_name}-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*",
        "${var.source_bucket_arn}",
        "${var.source_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.connection.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}



resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.pipeline_name}-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

data "aws_kms_alias" "s3kmskey" {
  name = "alias/aws/s3"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ListObjectsInBucket",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:ListBucket",
        "Resource" : "${aws_s3_bucket.codepipeline_bucket.arn}"
      },
      {
        "Sid" : "AllObjectActions",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:*Object*",
        "Resource" : "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      }
    ]
  })
}
