output "site_url" {
  value = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "domain_name" {
  value = aws_cloudfront_distribution.site.domain_name
}

output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}

output "distribution_id" {
  value = aws_cloudfront_distribution.site.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.site.arn
}

output "kms_key_arn" {
  value = aws_kms_key.site.arn
}
