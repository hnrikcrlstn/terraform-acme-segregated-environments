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
  source  = "app.terraform.io/ACME-Segregated-Environments/ACME-workspace-controller-module/tfc"
  version = "1.0.0"

  github_organization = each.value.github_organization
  tfe_organization    = each.value.tfe_organization
  workspace_settings  = each.value.workspace_settings
  oauth_token_id      = var.oauth_token_id

}

