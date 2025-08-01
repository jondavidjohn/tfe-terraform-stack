variable "tfe_token" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "hostname" {
  type = string
}

variable "organization_name" {
  type = string
}

variable "oauth_client_id" {
  type = string
}

variable "branch" {
  type = string
}

variable "repo" {
  type = string
}

variable "visible_team_users" {
  type = set(string)
}

variable "secret_team_users" {
  type = set(string)
}

required_providers {
  tfe = {
    source  = "hashicorp/tfe"
    version = "~> 0.63.0"
  }
}

provider "tfe" "this" {
  config {
    token    = var.tfe_token
    hostname = var.hostname
  }
}

component "workspaces" {
  source = "./workspaces"

  inputs = {
    organization_name = var.organization_name
    oauth_client_id   = "not-an-id"
    #oauth_client_id   = var.oauth_client_id
    branch            = var.branch
    repo              = var.repo
  }

  providers = {
    tfe = provider.tfe.this
  }
}

component "teams" {
  source = "./teams"

  inputs = {
    workspace_ids      = component.workspaces.ids
    organization_name  = var.organization_name
    visible_team_users = var.visible_team_users
    secret_team_users  = var.secret_team_users
  }

  providers = {
    tfe = provider.tfe.this
  }
}
