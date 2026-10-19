variable "region" {
  description = "Home region"
  type        = string
  default     = "us-east-2"
}

variable "project" {
  description = "Short project name; must match the bootstrap project name"
  type        = string
  default     = "portfolio"
}

# Cost switches. WAF and Security Hub cost money after their free use,
# so you can turn them off with a one-line pull request.
variable "enable_waf" {
  description = "Attach an AWS WAF web ACL to CloudFront (about $9/month while on)"
  type        = bool
  default     = true
}

variable "enable_compliance" {
  description = "Turn on AWS Config recording and Config rules"
  type        = bool
  default     = true
}

variable "enable_security_hub" {
  description = "Turn on Security Hub CSPM with the AWS Foundational Security Best Practices standard"
  type        = bool
  default     = true
}
