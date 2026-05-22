terraform {
  required_version = "~> 1.15.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.1"
    }
  }
}
