variable "github_organization" {
  type        = string
  description = "Github username"
  default     = "hnrikcrlstn"
}

variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization"
  default     = "ACME-Segregated-Environments"
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
      manual_confirm    = optional(bool, true)
      wait_for_run      = optional(bool, true)
      retry_attempts    = optional(number, 3)
      retry_backoff_min = optional(number, 5)
    }))
    destroy = optional(object({
      manual_confirm    = optional(bool, true)
      wait_for_run      = optional(bool, true)
      retry_attempts    = optional(number, 3)
      retry_backoff_min = optional(number, 5)
    }))
  })
}

variable "oauth_token_id" {
  type = string
  sensitive = true
}