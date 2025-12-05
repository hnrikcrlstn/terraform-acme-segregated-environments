provider "aws" {
  region = var.default_aws_region
  assume_role {
    role_arn = var.aws_role_arn
  }
}

provider "google" {
  region = var.default_google_region
  project = var.google_project_id
}