# Default provider: everything lives in us-east-2...
provider "aws" {
  region = var.region

  default_tags {
    tags = local.tags
  }
}

# ...except resources that CloudFront requires in us-east-1
# (the WAF web ACL, and an ACM certificate if you add a custom domain).
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = local.tags
  }
}

locals {
  tags = {
    Project   = var.project
    ManagedBy = "terraform"
    Repo      = "portfolio-aws"
  }
}
