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

variable "user_email" {
  type = string
}

variable "branch" {
  type = string
}

variable "repo" {
  type = string
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
    oauth_client_id   = var.oauth_client_id
    user_email        = var.user_email
    branch            = var.branch
    repo              = var.repo
  }

  providers = {
    tfe = provider.tfe.this
  }
}
