terraform {
  cloud {

    organization = "ACME-Segregated-Environments"
    workspaces {
      name = "acme-resource-manager"
    }
  }

}
module "workspace" {
  for_each = var.workspaces_to_deploy
  source   = "./modules/tfe-workspace"

  github_organization = each.value.github_organization
  tfe_organization    = each.value.tfe_organization
  workspace_settings  = each.value.workspace_settings
  oauth_token_id      = var.oauth_token_id

  apply = {
    manual_confirm    = try(each.value.workspaces_to_deploy.apply.manual_confirm, null)
    wait_for_run      = try(each.value.workspaces_to_deploy.apply.wait_for_run, null)
    retry_attempts    = try(each.value.workspaces_to_deploy.apply.retry_attempts, null)
    retry_backoff_min = try(each.value.workspaces_to_deploy.apply.retry_backoff_min, null)
  }

  destroy = {
    manual_confirm    = try(each.value.workspaces_to_deploy.destroy.manual_confirm, null)
    wait_for_run      = try(each.value.workspaces_to_deploy.destroy.wait_for_run, null)
    retry_attempts    = try(each.value.workspaces_to_deploy.destroy.retry_attempts, null)
    retry_backoff_min = try(each.value.workspaces_to_deploy.destroy.retry_backoff_min, null)
  }
}

