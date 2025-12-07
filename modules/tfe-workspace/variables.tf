variable "github_organization" {
  type        = string
  description = "Github username"
}

variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization"
}

variable "workspaces_to_deploy" {
  type = map(object({
    github_organization = string
    tfe_organization    = string
    workspace_settings = object({
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
  }))
}


variable "oauth_token_id" {
  type      = string
  sensitive = true
}
