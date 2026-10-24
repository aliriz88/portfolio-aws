resource "aws_s3_bucket" "site" {
  bucket        = "${var.project}-site-${data.aws_caller_identity.current.account_id}"
  force_destroy = true # lets terraform destroy empty it; fine for a learning project
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.site.arn
    }
    bucket_key_enabled = true
  }
}

# Phase 6: clean up old object versions so versioning doesn't grow forever
resource "aws_s3_bucket_lifecycle_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Only this distribution may read objects, and only over HTTPS
data "aws_iam_policy_document" "site_bucket" {
  statement {
    sid       = "AllowCloudFrontOAC"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.site.arn]
    }
  }

  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.site.arn, "${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket     = aws_s3_bucket.site.id
  policy     = data.aws_iam_policy_document.site_bucket.json
  depends_on = [aws_s3_bucket_public_access_block.site]
}

# ---------- Website files ----------
locals {
  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    json = "application/json"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    svg  = "image/svg+xml"
    ico  = "image/x-icon"
    txt  = "text/plain"
  }

  # Generated files win over a file of the same name in site_dir
  static_files = setsubtract(fileset(var.site_dir, "**"), keys(var.generated_files))
}

resource "aws_s3_object" "static" {
  for_each = local.static_files

  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "${var.site_dir}/${each.value}"
  source_hash  = filemd5("${var.site_dir}/${each.value}") # etag isn't an MD5 under SSE-KMS
  content_type = lookup(local.mime_types, lower(regex("[^.]+$", each.value)), "application/octet-stream")

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.site]
}

resource "aws_s3_object" "generated" {
  for_each = var.generated_files

  bucket       = aws_s3_bucket.site.id
  key          = each.key
  content      = each.value
  content_type = lookup(local.mime_types, lower(regex("[^.]+$", each.key)), "application/octet-stream")

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.site]
}
