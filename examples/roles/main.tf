module "app_registration" {
  source  = "cloudnationhq/aadapp/azure"
  version = "~> 1.0"

  registration = {
    display_name = "app-roles-demo-dev"

    app_roles = {
      admin = {
        id                   = "00000000-0000-0000-0000-000000000001"
        display_name         = "Admin"
        description          = "Full access to all resources."
        allowed_member_types = ["User"]
        value                = "Admin"
      }
      reader = {
        id                   = "00000000-0000-0000-0000-000000000002"
        display_name         = "Reader"
        description          = "Read-only access to all resources."
        allowed_member_types = ["User"]
        value                = "Reader"
      }
    }

    service_principal = {
      app_role_assignment_required = true
    }
  }
}
