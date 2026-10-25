output "config_bucket" {
  value = aws_s3_bucket.config.bucket
}

output "config_rule_names" {
  value = [for r in aws_config_config_rule.managed : r.name]
}

output "security_hub_enabled" {
  value = var.enable_security_hub
}
