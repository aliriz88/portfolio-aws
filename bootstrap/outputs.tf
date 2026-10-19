output "state_bucket" {
  value = aws_s3_bucket.tfstate.bucket
}

output "state_kms_key_arn" {
  value = aws_kms_key.tfstate.arn
}

output "plan_role_arn" {
  value = aws_iam_role.plan.arn
}

output "apply_role_arn" {
  value = aws_iam_role.apply.arn
}

# Copy these into GitHub: Settings > Secrets and variables > Actions > Variables
output "github_actions_variables" {
  value = {
    AWS_PLAN_ROLE_ARN    = aws_iam_role.plan.arn
    AWS_APPLY_ROLE_ARN   = aws_iam_role.apply.arn
    TF_STATE_BUCKET      = aws_s3_bucket.tfstate.bucket
    TF_STATE_KMS_KEY_ARN = aws_kms_key.tfstate.arn
  }
}
