variable "default_ec2_instance_type" {
  type        = string
  description = "EC2 instance type for the web server"
  default     = "t2.micro"
}

variable "default_ec2_instance_name" {
  type        = string
  description = "Ec2 Instance Name"
  default     = "ACME Terraform"
}

variable "default_aws_region" {
  type        = string
  description = "AWS server region"
  default     = "us-west-2"
}

variable "aws_role_arn" {
  type        = string
  description = "IAM user arn"
  default     = "arn:aws:iam::586986619204:role/terraform-acme-role"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "default_google_region" {
  type        = string
  description = "Default region for Google resources"
  default     = "europe-north-1"
}

variable "default_google_zone" {
  type        = string
  description = "Default zone for Google resources"
  default     = "europe-north1-a"
}

variable "google_project_id" {
  type        = string
  description = "Google Project name"
  default     = "terraform-acme-case"
}
