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
  project_id   = var.tfe_project

  vcs_repo {
    identifier     = var.workspace_settings.vcs_repo.identifier
    branch         = var.workspace_settings.vcs_repo.branch
    oauth_token_id = var.oauth_token_id
  }

  force_delete = var.force_delete
}

resource "tfe_variable" "terraform_vars" {
  for_each = var.terraform_vars

  key          = each.key
  value        = each.value
  category     = "terraform"
  workspace_id = tfe_workspace.this.id
  hcl          = false
  sensitive    = false
}

resource "tfe_run" "destroy_run" {
  workspace_id = tfe_workspace.this.id
  message      = "Controller-initiated destroy before workspace cleanup"
  destroy      = true
  wait_for_run = true
}
