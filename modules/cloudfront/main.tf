resource "aws_s3_bucket" "app_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "app_bucket_acl" {
  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.module}/build"
}

resource "aws_s3_object" "s3_object" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.app_bucket.id
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content

  etag = each.value.digests.md5
}

resource "aws_s3_bucket_website_configuration" "static_hosting" {
  bucket = aws_s3_bucket.app_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = aws_s3_bucket.app_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.app_bucket.bucket_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.app_bucket.bucket_domain_name

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
    compress    = true

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  enabled             = true
  default_root_object = "index.html"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.app_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.app_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
