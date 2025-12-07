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
    })
  }))
}

variable "oauth_token_id" {
  type = string
}
