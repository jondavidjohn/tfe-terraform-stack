terraform {
  required_providers {
    tfe = {
      version  = "~> 0.43.0"
    }
  }
}

variable "organization_name" {
  type = string
}

variable "visible_team_users" {
  type = set(string)
}

variable "secret_team_users" {
  type = set(string)
}

data "tfe_organization_membership" "visible_team_members" {
  for_each      = var.visible_team_members
  organization  = var.organization_name
  email         = each.value
}

data "tfe_organization_membership" "secret_team_members" {
  for_each      = var.secret_team_members
  organization  = var.organization_name
  email         = each.value
}

variable "organization_name" {
  type = string
}

variable "workspace_ids" {
  type = list
}

resource "tfe_team" "visible_team" {
  name         = "visible-team"
  organization = var.organization_name
  visibility   = "organization"
}

resource "tfe_team_access" "team_workspace_access" {
  for_each     = var.workspace_ids
  access       = "read"
  team_id      = tfe_team.visible_team
  workspace_id = each.value
}

resource "tfe_team" "secret_team" {
  name         = "secret-team"
  organization = var.organization_name
}

resource "tfe_team_access" "secret_team_workspace_access" {
  for_each     = var.workspace_ids
  access       = "read"
  team_id      = tfe_team.secret_team.id
  workspace_id = each.value
}

resource "tfe_team_organization_member" "visible_team_user_membership" {
  for_each                   = toset([for m in tfe_organization_membership.visible_team_members : m.id])
  team_id                    = tfe_team.visible_team.id
  organization_membership_id = each.value
}

resource "tfe_team_organization_member" "secret_team_user_membership" {
  for_each                   = toset([for m in tfe_organization_membership.secret_team_members : m.id])
  team_id                    = tfe_team.secret_team.id
  organization_membership_id = each.value
}
