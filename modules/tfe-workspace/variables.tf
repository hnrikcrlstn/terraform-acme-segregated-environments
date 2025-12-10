variable "github_organization" {
  type        = string
  description = "Github username"
}

variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization"
}

variable "tfe_project" {
  type        = string
  description = "Terraform Cloud project"
}

variable "oauth_token_id" {
  type      = string
  sensitive = true
}

variable "workspace_settings" {
  type = object({
    name                           = string
    auto_destroy_activity_duration = optional(string)
    vcs_repo = object({
      branch     = string
      identifier = string
    })
  })
}

variable "terraform_vars" {
  type        = map(string)
  default     = {}
  description = "Variables to create inside the new workspace"
}
