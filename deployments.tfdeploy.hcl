store "varset" "tokens" {
  id       = "varset-5Z9xShZJbbrmAnGG"
  category = "env"
}

deployment "local" {
  inputs = {
    tfe_token         = store.varset.tokens.LOCAL_TFE_TOKEN
    hostname          = "jondavidjohn.ngrok.io"
    organization_name = "hashicorp"
    oauth_client_id   = "oc-Zq9rND8i3QcdWYZe"
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

# deployment "oasis" {
#   inputs = {
#     tfe_token         = store.varset.tokens.OASIS_TFE_TOKEN
#     hostname          = "app.staging.terraform.io"
#     organization_name = "stack-target"
#     oauth_client_id   = "oc-Pmy5RLQo1Y9pWsT8"
#     branch            = "master"
#     repo              = "jondavidjohn/terraform-tests"
#     visible_team_users = [
#       "jjohnson@hashicorp.com",
#     ]
#     secret_team_users = [
#       "jjohnson@hashicorp.com",
#     ]
#   }
# }
