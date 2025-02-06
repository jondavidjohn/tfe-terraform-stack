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


locals {
  visible_team_access_set = setproduct(var.workspace_ids, toset([for t in tfe_team.visible_teams : t.id]))
  visible_team_access_map = { for a in local.visible_team_access_set : "${a[0]}-${a[1]}" => {
    "workspace_id" = a[0],
    "team_id" = a[1],
  }}

  secret_team_access_set  = setproduct(var.workspace_ids, toset([for t in tfe_team.secret_teams : t.id]))
  secret_team_access_map = { for a in local.secret_team_access_set : "${a[0]}-${a[1]}" => {
    "workspace_id" = a[0],
    "team_id" = a[1],
  }}

  visible_team_membership_set = setproduct(
    toset([for m in data.tfe_organization_membership.visible_team_members : m.id]),
    toset([for t in tfe_team.visible_teams : t.id])
  )
  visible_team_membership_map = { for a in local.visible_team_membership_set : "${a[0]}-${a[1]}" => {
    "membership_id" = a[0],
    "team_id" = a[1],
  }}

  secret_team_membership_set = setproduct(
    toset([for m in data.tfe_organization_membership.secret_team_members : m.id]),
    toset([for t in tfe_team.secret_teams : t.id])
  )
  secret_team_membership_map = { for a in local.secret_team_membership_set : "${a[0]}-${a[1]}" => {
    "membership_id" = a[0],
    "team_id" = a[1],
  }}
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

resource "tfe_team_access" "visible_team_workspace_access" {
  for_each     = local.visible_team_access_map
  access       = "read"
  workspace_id = each.value.workspace_id
  team_id      = each.value.team_id
}

resource "tfe_team" "secret_teams" {
  count = 3
  name         = "secret-team-${count.index}"
  organization = var.organization_name
  visibility   = "organization"
}

resource "tfe_team_access" "secret_team_workspace_access" {
  for_each     = local.secret_team_access_map
  access       = "read"
  workspace_id = each.value.workspace_id
  team_id      = each.value.team_id
}

resource "tfe_team_organization_member" "visible_team_user_membership" {
  for_each                   = local.visible_team_membership_map
  organization_membership_id = each.value.membership_id
  team_id                    = each.value.team_id
}

resource "tfe_team_organization_member" "secret_team_user_membership" {
  for_each                   = local.secret_team_membership_map
  organization_membership_id = each.value.membership_id
  team_id                    = each.value.team_id
}
