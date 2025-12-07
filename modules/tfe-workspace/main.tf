terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.71.0"
    }
  }
}

resource "tfe_workspace" "this" {
  name         = var.workspace_settings.name
  organization = var.tfe_organization

  # Basic VCS config
  vcs_repo {
    identifier     = var.workspace_settings.vcs_repo.identifier
    branch         = var.workspace_settings.vcs_repo.branch
    oauth_token_id = var.oauth_token_id
  }

  # Optional apply settings
  dynamic "apply" {
    for_each = var.workspace_settings.apply[*]
    content {
      manual_confirm    = try(apply.value.manual_confirm, null)
      wait_for_run      = try(apply.value.wait_for_run, null)
      retry_attempts    = try(apply.value.retry_attempts, null)
      retry_backoff_min = try(apply.value.retry_backoff_min, null)
    }
  }

  # Optional destroy settings
  dynamic "destroy" {
    for_each = var.workspace_settings.destroy[*]
    content {
      manual_confirm    = try(destroy.value.manual_confirm, null)
      wait_for_run      = try(destroy.value.wait_for_run, null)
      retry_attempts    = try(destroy.value.retry_attempts, null)
      retry_backoff_min = try(destroy.value.retry_backoff_min, null)
    }
  }
}
