terraform {
  required_version = "~> 1.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.42.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.7"
    }
  }
}
