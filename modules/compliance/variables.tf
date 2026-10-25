variable "project" {
  description = "Short project name, used in resource names"
  type        = string
}

variable "enable_security_hub" {
  description = "Turn on Security Hub CSPM with the AWS Foundational Security Best Practices standard"
  type        = bool
  default     = true
}
