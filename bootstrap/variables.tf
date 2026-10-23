variable "region" {
  description = "Home region for the project"
  type        = string
  default     = "us-east-2"
}

variable "project" {
  description = "Short project name, used in resource names and the Project tag"
  type        = string
  default     = "portfolio"
}

variable "alert_email" {
  description = "Email address that receives budget alerts"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository allowed to deploy, as owner/repo (for example jane/portfolio-aws)"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repo))
    error_message = "github_repo must look like owner/repo."
  }
}

variable "github_owner_id" {
  description = "Numeric ID of the GitHub user or org that owns the repo (part of GitHub's OIDC sub claim)"
  type        = string
}

variable "github_repo_id" {
  description = "Numeric ID of the GitHub repo (part of GitHub's OIDC sub claim)"
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly budget; you get emails at 50% actual and 100% forecast"
  type        = number
  default     = 10
}
