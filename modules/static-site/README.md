# Module: static-site (Phase 2)

Private S3 bucket + CloudFront distribution, encrypted with a customer-managed KMS key.

Build in this module:

- [ ] KMS key with rotation, an alias, and a key policy that lets only this CloudFront distribution decrypt
- [ ] S3 bucket: Block Public Access, versioning, SSE-KMS with bucket key, TLS-only bucket policy
- [ ] CloudFront distribution with Origin Access Control (OAC), HTTPS redirect, managed security headers
- [ ] Bucket policy allowing `s3:GetObject` only from this distribution (`AWS:SourceArn`)
- [ ] Upload the website files, plus any `generated_files` (config.js)
- [ ] Optional `web_acl_arn` input for the WAF (Phase 4)

Inputs: `project`, `site_dir`, `generated_files`, `web_acl_arn`, `price_class`
Outputs: `site_url`, `domain_name`, `bucket_name`, `distribution_id`, `distribution_arn`, `kms_key_arn`

The full code is in the build guide, Phase 2.
