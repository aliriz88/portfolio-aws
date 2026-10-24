variable "project" {
  description = "Short project name, used in resource names"
  type        = string
}

variable "allowed_origin" {
  description = "The only browser origin allowed by CORS, e.g. https://d123.cloudfront.net"
  type        = string
}

variable "lambda_source_file" {
  description = "Path to the Lambda's Python file"
  type        = string
}

variable "throttle_rate_limit" {
  description = "Steady-state requests per second for the API"
  type        = number
  default     = 5
}

variable "throttle_burst_limit" {
  description = "Burst requests for the API"
  type        = number
  default     = 10
}

variable "log_retention_days" {
  description = "Days to keep Lambda and API logs"
  type        = number
  default     = 14
}
