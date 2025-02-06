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

variable "workspace_ids" {
  type = set(string)
}

data "tfe_organization_membership" "visible_team_members" {
  for_each      = var.visible_team_users
  organization  = var.organization_name
  email         = each.value
}

data "tfe_organization_membership" "secret_team_members" {
  for_each      = var.secret_team_users
  organization  = var.organization_name
  email         = each.value
}

resource "tfe_team" "visible_teams" {
  count = 3
  name         = "visible-team-${count.index}"
  organization = var.organization_name
  visibility   = "organization"
}

resource "tfe_team_access" "team_workspace_access" {
  for_each     = setproduct(var.workspace_ids, toset([for t in tfe_team.visible_teams : t.id]))
  access       = "read"
  workspace_id = each.value[0]
  team_id      = each.value[1]
}

resource "tfe_team" "secret_teams" {
  count = 3
  name         = "secret-team-${count.index}"
  organization = var.organization_name
  visibility   = "organization"
}

resource "tfe_team_access" "secret_team_workspace_access" {
  for_each     = setproduct(var.workspace_ids, toset([for t in tfe_team.secret_teams : t.id]))
  access       = "read"
  workspace_id = each.value[0]
  team_id      = each.value[1]
}

resource "tfe_team_organization_member" "visible_team_user_membership" {
  for_each                   = setproduct(
    toset([for m in data.tfe_organization_membership.visible_team_members : m.id]),
    toset([for t in tfe_team.visible_teams : t.id])
  )
  organization_membership_id = each.value[0]
  team_id                    = each.value[1]
}

resource "tfe_team_organization_member" "secret_team_user_membership" {
  for_each                   = setproduct(
    toset([for m in data.tfe_organization_membership.visible_team_members : m.id]),
    toset([for t in tfe_team.secret_teams : t.id])
  )
  organization_membership_id = each.value[0]
  team_id                    = each.value[1]
}
