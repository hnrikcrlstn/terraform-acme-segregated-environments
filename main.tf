terraform {
  required_version = ">= 1.2"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.71.0"
    }
  }
}

module "workspace" {
  source   = "./modules/tfe-workspace"
  for_each = var.workspaces_to_deploy

  github_organization = each.value.github_organization
  tfe_organization    = each.value.tfe_organization
  tfe_project         = each.value.tfe_project
  oauth_token_id      = var.oauth_token_id

  workspace_settings = each.value.workspace_settings
  terraform_vars     = try(each.value.terraform_vars, {})
}
