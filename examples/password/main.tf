module "app_registration" {
  source  = "cloudnationhq/aadapp/azure"
  version = "~> 1.0"

  registration = {
    display_name = "daemon-demo-dev"

    required_resource_accesses = {
      msgraph = {
        resource_app_id = "00000003-0000-0000-c000-000000000000"
        resource_accesses = {
          user_read_write_all = {
            id   = "df021288-bdef-4463-88db-98f22de89214"
            type = "Role"
          }
        }
      }
    }

    password = {
      display_name = "client-secret"
    }

    service_principal = {}
  }
}
