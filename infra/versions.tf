terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  # Partial backend config: bucket and kms_key_id are passed at init time
  # (backend.hcl locally, repository variables in GitHub Actions).
  backend "s3" {
    key          = "portfolio/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true # S3-native state locking, no DynamoDB table needed
  }
}
