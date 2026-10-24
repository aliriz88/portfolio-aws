# Customer-managed key for the website bucket.
# The key policy is a separate resource because it needs the distribution ARN,
# and the distribution needs the bucket, which needs the key.

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "site" {
  description             = "Encrypts the ${var.project} website bucket"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "site" {
  name          = "alias/${var.project}-site"
  target_key_id = aws_kms_key.site.key_id
}

data "aws_iam_policy_document" "site_key" {
  # Lets IAM policies in this account grant use of the key
  statement {
    sid       = "AccountAdministration"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  # CloudFront (this distribution only) may decrypt objects it fetches through OAC
  statement {
    sid       = "AllowCloudFrontDecrypt"
    actions   = ["kms:Decrypt"]
    resources = ["*"]

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
}

resource "aws_kms_key_policy" "site" {
  key_id = aws_kms_key.site.id
  policy = data.aws_iam_policy_document.site_key.json
}
