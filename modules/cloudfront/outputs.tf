output "cloudfront_url" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.app_bucket.arn
}
