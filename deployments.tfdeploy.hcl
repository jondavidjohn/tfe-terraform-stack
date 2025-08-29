store "varset" "tokens" {
  id       = "varset-5Z9xShZJbbrmAnGG"
  category = "env"
}

deployment "local" {
  inputs = {
    tfe_token         = store.varset.tokens.LOCAL_TFE_TOKEN
    hostname          = "tfcdev-8e6580d7.ngrok.app"
    organization_name = "hashicorp"
    oauth_client_id   = "oc-VCvZRvfZwgtaz2qk"
    branch            = "master"
    repo              = "jondavidjohn/terraform-tests"
    visible_team_users = [
      "admin@hashicorp.com",
      "jjohnson@hashicorp.com",
    ]
    secret_team_users = [
      "admin@hashicorp.com",
    ]
  }
}

deployment "local_two" {
  inputs = {
    tfe_token         = store.varset.tokens.LOCAL_TFE_TOKEN
    hostname          = "tfcdev-8e6580d7.ngrok.app"
    organization_name = "hashicorp_two"
    oauth_client_id   = "oc-ReokJJDxSWBqGEa7"
    branch            = "master"
    repo              = "jondavidjohn/terraform-tests"
    visible_team_users = [
      "admin@hashicorp.com",
      "jjohnson@hashicorp.com",
    ]
    secret_team_users = [
      "admin@hashicorp.com",
    ]
  }
}

deployment "local_three" {
  inputs = {
    tfe_token         = store.varset.tokens.LOCAL_TFE_TOKEN
    hostname          = "tfcdev-8e6580d7.ngrok.app"
    organization_name = "hashicorp_three"
    oauth_client_id   = "oc-MVL2ve3SdVSh8sT8"
    branch            = "master"
    repo              = "jondavidjohn/terraform-tests"
    visible_team_users = [
      "admin@hashicorp.com",
      "jjohnson@hashicorp.com",
    ]
    secret_team_users = [
      "admin@hashicorp.com",
    ]
  }
}
