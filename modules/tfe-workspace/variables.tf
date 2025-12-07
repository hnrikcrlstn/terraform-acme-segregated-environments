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

variable "force_delete" {
  type    = bool
  default = true
}

variable "workspace_settings" {
  type = object({
    name                           = string
    auto_destroy_activity_duration = optional(string)
    vcs_repo = object({
      branch     = string
      identifier = string
    })
    apply = optional(object({
      manual_confirm    = optional(bool)
      wait_for_run      = optional(bool)
      retry_attempts    = optional(number)
      retry_backoff_min = optional(number)
    }))
    destroy = optional(object({
      manual_confirm    = optional(bool)
      wait_for_run      = optional(bool)
      retry_attempts    = optional(number)
      retry_backoff_min = optional(number)
    }))
  })
}

variable "terraform_vars" {
  type        = map(string)
  default     = {}
  description = "Variables to create inside the new workspace"
}


variable "tfc_token" {
  type        = string
  sensitive   = true
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
}