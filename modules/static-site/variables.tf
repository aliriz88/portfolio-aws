variable "project" {
  description = "Short project name, used in resource names"
  type        = string
}

variable "site_dir" {
  description = "Local folder whose files are uploaded to the bucket"
  type        = string
}

variable "generated_files" {
  description = "Extra files built from Terraform values: object key => file content"
  type        = map(string)
  default     = {}
}

variable "web_acl_arn" {
  description = "ARN of a CLOUDFRONT-scoped WAF web ACL to attach (null = none)"
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100" # North America + Europe edges only
}
