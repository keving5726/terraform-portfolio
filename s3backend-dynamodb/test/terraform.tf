terraform {
  required_version = "~> 1.15.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.3.0"
    }
  }
}
