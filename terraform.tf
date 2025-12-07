terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.71.0"
    }
  }
}