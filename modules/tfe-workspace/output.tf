output "workspace_id" {
  value = tfe_workspace.this.id
}

output "organization" {
  value = tfe_workspace.this.organization
}

output "workspace_name" {
  value = tfe_workspace.this.name
}