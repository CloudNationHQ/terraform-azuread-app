module "api" {
  source  = "cloudnationhq/aadapp/azure"
  version = "~> 1.0"

  registration = {
    display_name    = "api-demo-dev"
    identifier_uris = ["api://api-demo-dev"]

    api = {
      requested_access_token_version = 2

      oauth2_permission_scopes = {
        read = {
          id                         = "00000000-0000-0000-0000-000000000001"
          admin_consent_description  = "Allow the application to read data on behalf of the signed-in user."
          admin_consent_display_name = "Read data"
          value                      = "data.read"
        }
      }
    }

    pre_authorized_applications = {
      client = {
        authorized_client_id = module.client.registration.client_id
        permission_ids       = ["00000000-0000-0000-0000-000000000001"]
      }
    }

    service_principal = {}
  }
}

module "client" {
  source  = "cloudnationhq/aadapp/azure"
  version = "~> 1.0"

  registration = {
    display_name = "client-demo-dev"

    service_principal = {}
  }
}
