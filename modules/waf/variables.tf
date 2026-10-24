variable "project" {
  description = "Short project name, used in resource names"
  type        = string
}

variable "rate_limit" {
  description = "Max requests from one IP in any 5-minute window before it is blocked"
  type        = number
  default     = 300
}

variable "log_retention_days" {
  description = "Days to keep WAF logs"
  type        = number
  default     = 14
}
