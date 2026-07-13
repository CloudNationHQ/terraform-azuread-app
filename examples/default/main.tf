module "app_registration" {
  source  = "cloudnationhq/aadapp/azure"
  version = "~> 1.0"

  registration = {
    display_name = "app-demo-dev"

    web = {
      redirect_uris = ["https://app.example.com/auth/callback"]
    }

    required_resource_accesses = {
      msgraph = {
        resource_app_id = "00000003-0000-0000-c000-000000000000"
        resource_accesses = {
          user_read = {
            id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
            type = "Scope"
          }
        }
      }
    }

    service_principal = {}
  }
}
