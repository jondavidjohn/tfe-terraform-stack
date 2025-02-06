store "varset" "tokens" {
  id       = "varset-ZJq9eszx1Tno7tAQ"
  category = "env"
}

deployment "local" {
  inputs = {
    tfe_token = store.varset.tokens.TFE_TOKEN
    hostname = "jondavidjohn.ngrok.io"
    organization_name = "admin"
    oauth_client_id = ""
    user_email = "admin@hashicorp.com"
    branch = "master"
    repo = "jondavidjohn/terraform-tests"
  }
}
