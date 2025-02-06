store "varset" "tokens" {
  id       = "varset-ZJq9eszx1Tno7tAQ"
  category = "env"
}

deployment "local" {
  inputs = {
    tfe_token         = store.varset.tokens.TFE_TOKEN
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
