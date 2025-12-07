terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.71.0"
    }
  }
}

resource "tfe_workspace" "workspace" {
  name         = var.workspace_settings.name
  organization = var.tfe_organization
  project_id   = var.tfe_project

  lifecycle {
    prevent_destroy = true
  }

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
  workspace_id = tfe_workspace.workspace.id
  hcl          = false
  sensitive    = false
}

resource "null_resource" "destroy_run" {
  triggers = {
    workspace_id = tfe_workspace.workspace.id
  }

  provisioner "local-exec" {
    command = <<EOT
curl \
  --fail \
  --header "Authorization: Bearer ${var.tfc_token}" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{
    "data": {
      "type": "runs",
      "attributes": {
        "is-destroy": true,
        "message": "Controller-initiated destroy before workspace deletion"
      },
      "relationships": {
        "workspace": {
          "data": { "type": "workspaces", "id": "${tfe_workspace.delete_workspace.id}" }
        }
      }
    }
  }' \
  https://${var.tfc_hostname}/api/v2/runs
EOT
  }
}

resource "null_resource" "wait_for_destroy" {
  depends_on = [null_resource.destroy_run]

  provisioner "local-exec" {
    command = <<EOT
run_id=$(curl -s \
  --header "Authorization: Bearer ${var.tfc_token}" \
  https://${var.tfc_hostname}/api/v2/workspaces/${tfe_workspace.delete_workspace.id}/runs \
  | jq -r '.data[0].id')

status="unknown"

while true; do
  status=$(curl -s \
    --header "Authorization: Bearer ${var.tfc_token}" \
    https://${var.tfc_hostname}/api/v2/runs/$run_id \
    | jq -r '.data.attributes.status')

  echo "Run status: $status"

  if [ "$status" = "applied" ] || [ "$status" = "errored" ] || [ "$status" = "canceled" ]; then
    break
  fi

  sleep 5
done
EOT
  }
}

resource "tfe_workspace" "delete_workspace" {
  name         = var.workspace_settings.name
  organization = var.tfe_organization
  force_delete = true

  # normal workspace creation stuff...
}

resource "null_resource" "delete_workspace" {
  depends_on = [
    null_resource.wait_for_destroy,
  ]

  provisioner "local-exec" {
    command = <<EOT
curl \
  --fail \
  --header "Authorization: Bearer ${var.tfc_token}" \
  --request DELETE \
  https://${var.tfc_hostname}/api/v2/organizations/${var.tfe_organization}/workspaces/${tfe_workspace.delete_workspace.name}
EOT
  }
}