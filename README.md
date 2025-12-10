# acme-resource-manager-module

## Installation
Call the module with
#### main.tf
```hcl
module "workspace_create_module" {
  for_each = var.workspaces_to_deploy
  source              = "app.terraform.io/ACME-backend-organization/acme-backend-module/tfc"
  version             = "1.3.7"
  github_organization = each.value.github_organization
  tfe_organization    = each.value.tfe_organization
  workspace_settings = {
    name = each.value.workspace_settings.name
    auto_destroy_activity_duration = try(each.value.workspace_settings.auto_destroy_activity_duration, null)
    vcs_repo = {
      branch     = each.value.workspace_settings.vcs_repo.branch
      identifier = each.value.workspace_settings.vcs_repo.identifier
    }
  }
}
```
#### terraform.tvars
Example of `terraform.tvars` when running the module
```hcl
workspaces_to_deploy = {
  workspace_1 = {
    github_organization = "GitHub Username"
    tfe_organization    = "Terraform Cloud Organization"
    tfe_project         = "Terraform Cloud Project ID"
    workspace_settings = {
      name = "Workspace Name"
      vcs_repo = {
        branch     = "branch"
        identifier = "Github/Repo"
      }
      auto_destroy_activity_duration = "1d"
    }

    force_delete = true

    terraform_vars = {
      ec2_instance_type = "EC2 Instance type"
      ec2_instance_name = "EC2 Instance Name"
      environment       = "Environment name"
    }

  }

}

```

### Environment variables
Set up the environment variables needed to authenticate to the chosen providers in Terraform Cloud.

## Usage
When the devs at ACME updates a branch used by any workspace, the corresponding workspace in Terraform Cloud will update.
To prevent overdue dev and staging environments, they should also have a `auto_destroy_activity_duration` included to auto destroy them if they are left inactive

## Additional relevant modules
* https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_run