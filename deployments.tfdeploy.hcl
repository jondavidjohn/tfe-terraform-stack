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
