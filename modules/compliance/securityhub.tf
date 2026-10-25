# Security Hub CSPM (formerly just "Security Hub") runs the AWS Foundational
# Security Best Practices checks on top of AWS Config and gathers findings.
# 30-day free trial per account and region, then charged per check.

resource "aws_securityhub_account" "this" {
  count = var.enable_security_hub ? 1 : 0

  enable_default_standards  = false # we subscribe explicitly below
  control_finding_generator = "SECURITY_CONTROL"
  auto_enable_controls      = true
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  count = var.enable_security_hub ? 1 : 0

  standards_arn = "arn:aws:securityhub:${local.region}::standards/aws-foundational-security-best-practices/v/1.0.0"

  depends_on = [
    aws_securityhub_account.this,
    aws_config_configuration_recorder_status.this,
  ]
}
