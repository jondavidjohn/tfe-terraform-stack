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

variable "oauth_client_id" {
  type = string
}

variable "user_email" {
  type = string
}

variable "branch" {
  type = string
}

variable "repo" {
  type = string
}

data "tfe_organization_membership" "user" {
  organization  = var.organization_name
  email = var.user_email
}

data "tfe_oauth_client" "github" {
  oauth_client_id = var.oauth_client_id
}

resource "tfe_workspace" "random_workspace" {
  organization      = var.organization_name
  name              = "randomz"
  auto_apply        = true
  queue_all_runs    = true
  working_directory = "./random"

  vcs_repo {
    identifier     = var.repo
    branch         = var.branch
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace" "variable_dump_workspace" {
  organization      = var.organization_name
  name              = "variable_dump"
  auto_apply        = true
  queue_all_runs    = true
  working_directory = "./variables-dump"

  vcs_repo {
    identifier     = var.repo
    branch         = var.branch
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace" "variable_repro_workspace" {
  organization      = var.organization_name
  name              = "variable_repro"
  auto_apply        = true
  queue_all_runs    = true
  working_directory = "./variables-repro"

  vcs_repo {
    identifier     = var.repo
    branch         = var.branch
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace" "tagged_vcs" {
  organization      = var.organization_name
  name              = "tagged_vcs"
  auto_apply        = true
  queue_all_runs    = true
  working_directory = "./random"
  tag_names         = ["prod", "application", "useast1"]

  vcs_repo {
    identifier     = var.repo
    branch         = var.branch
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace" "tagged" {
  organization      = var.organization_name
  name              = "tagged"
  auto_apply        = true
  queue_all_runs    = true
  working_directory = "./random"
  tag_names         = ["dev", "infra", "useast1"]
}

output "workspace_ids" {
  value = [
    tfe_workspace.random_workspace,
    tfe_workspace.variable_dump_workspace,
    tfe_workspace.variable_repro_workspace,
    tfe_workspace.tagged_vcs,
    tfe_workspace.tagged,
  ]
  description = "Created workspace ids"
}
