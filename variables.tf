variable "config" {
  description = "contains app registration configuration"
  type = object({
    display_name                   = string
    description                    = optional(string)
    sign_in_audience               = optional(string, "AzureADMyOrg")
    identifier_uris                = optional(set(string), [])
    group_membership_claims        = optional(set(string))
    owners                         = optional(set(string))
    device_only_auth_enabled       = optional(bool, false)
    fallback_public_client_enabled = optional(bool, false)
    logo_image                     = optional(string)
    marketing_url                  = optional(string)
    notes                          = optional(string)
    oauth2_post_response_required  = optional(bool, false)
    prevent_duplicate_names        = optional(bool, false)
    privacy_statement_url          = optional(string)
    service_management_reference   = optional(string)
    support_url                    = optional(string)
    tags                           = optional(set(string))
    template_id                    = optional(string)
    terms_of_service_url           = optional(string)

    password = optional(object({
      display_name = string
      end_date     = optional(string)
      start_date   = optional(string)
    }))

    api = optional(object({
      known_client_applications      = optional(set(string))
      mapped_claims_enabled          = optional(bool, false)
      requested_access_token_version = optional(number, 1)

      oauth2_permission_scopes = optional(map(object({
        id                         = string
        admin_consent_description  = string
        admin_consent_display_name = string
        enabled                    = optional(bool, true)
        type                       = optional(string, "User")
        user_consent_description   = optional(string)
        user_consent_display_name  = optional(string)
        value                      = optional(string)
      })), {})
    }))

    app_roles = optional(map(object({
      allowed_member_types = list(string)
      description          = string
      display_name         = string
      id                   = string
      enabled              = optional(bool, true)
      value                = optional(string)
    })), {})

    feature_tags = optional(object({
      custom_single_sign_on = optional(bool, false)
      enterprise            = optional(bool, false)
      gallery               = optional(bool, false)
      hide                  = optional(bool, false)
    }))

    optional_claims = optional(object({
      access_token = optional(map(object({
        name                  = optional(string)
        additional_properties = optional(list(string))
        essential             = optional(bool)
        source                = optional(string)
      })), {})
      id_token = optional(map(object({
        name                  = optional(string)
        additional_properties = optional(list(string))
        essential             = optional(bool)
        source                = optional(string)
      })), {})
      saml2_token = optional(map(object({
        name                  = optional(string)
        additional_properties = optional(list(string))
        essential             = optional(bool)
        source                = optional(string)
      })), {})
    }))

    public_client = optional(object({
      redirect_uris = optional(set(string), [])
    }))

    required_resource_accesses = optional(map(object({
      resource_app_id = string
      resource_accesses = map(object({
        id   = string
        type = string
      }))
    })), {})

    single_page_application = optional(object({
      redirect_uris = optional(set(string), [])
    }))

    web = optional(object({
      homepage_url  = optional(string)
      logout_url    = optional(string)
      redirect_uris = optional(set(string), [])
      implicit_grant = optional(object({
        access_token_issuance_enabled = optional(bool)
        id_token_issuance_enabled     = optional(bool)
      }))
    }))

    pre_authorized_applications = optional(map(object({
      authorized_client_id = string
      permission_ids       = set(string)
    })), {})

    service_principal = optional(object({
      account_enabled               = optional(bool, true)
      alternative_names             = optional(set(string))
      app_role_assignment_required  = optional(bool, false)
      description                   = optional(string)
      login_url                     = optional(string)
      notes                         = optional(string)
      notification_email_addresses  = optional(set(string))
      owners                        = optional(set(string))
      preferred_single_sign_on_mode = optional(string)
      tags                          = optional(set(string))
      use_existing                  = optional(bool, false)

      feature_tags = optional(object({
        custom_single_sign_on = optional(bool, false)
        enterprise            = optional(bool, false)
        gallery               = optional(bool, false)
        hide                  = optional(bool, false)
      }))

      saml_single_sign_on = optional(object({
        relay_state = optional(string)
      }))
    }))
  })
}
