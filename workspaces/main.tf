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

variable "branch" {
  type = string
}

variable "repo" {
  type = string
}

data "tfe_oauth_client" "github" {
  organization    = var.organization_name
  oauth_client_id = var.oauth_client_id
}

resource "tfe_workspace" "random_workspace" {
  organization      = var.organization_name
  name              = "random"
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

output "ids" {
  value = [
    tfe_workspace.random_workspace.id,
    tfe_workspace.variable_dump_workspace.id,
    tfe_workspace.variable_repro_workspace.id,
    tfe_workspace.tagged_vcs.id,
    tfe_workspace.tagged.id,
  ]
  description = "Created workspace ids"
}
