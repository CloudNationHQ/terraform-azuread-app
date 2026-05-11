# application registration
resource "azuread_application" "this" {
  display_name                   = var.registration.display_name
  description                    = var.registration.description
  sign_in_audience               = var.registration.sign_in_audience
  identifier_uris                = var.registration.identifier_uris
  group_membership_claims        = var.registration.group_membership_claims
  owners                         = var.registration.owners
  device_only_auth_enabled       = var.registration.device_only_auth_enabled
  fallback_public_client_enabled = var.registration.fallback_public_client_enabled
  logo_image                     = var.registration.logo_image
  marketing_url                  = var.registration.marketing_url
  notes                          = var.registration.notes
  oauth2_post_response_required  = var.registration.oauth2_post_response_required
  prevent_duplicate_names        = var.registration.prevent_duplicate_names
  privacy_statement_url          = var.registration.privacy_statement_url
  service_management_reference   = var.registration.service_management_reference
  support_url                    = var.registration.support_url
  tags                           = var.registration.tags
  template_id                    = var.registration.template_id
  terms_of_service_url           = var.registration.terms_of_service_url

  dynamic "password" {
    for_each = var.registration.password != null ? { this = {} } : {}

    content {
      display_name = var.registration.password.display_name
      end_date     = var.registration.password.end_date
      start_date   = var.registration.password.start_date
    }
  }

  dynamic "api" {
    for_each = var.registration.api != null ? { this = {} } : {}

    content {
      known_client_applications      = var.registration.api.known_client_applications
      mapped_claims_enabled          = var.registration.api.mapped_claims_enabled
      requested_access_token_version = var.registration.api.requested_access_token_version

      dynamic "oauth2_permission_scope" {
        for_each = coalesce(var.registration.api.oauth2_permission_scopes, {})

        content {
          id                         = oauth2_permission_scope.value.id
          admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
          admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
          enabled                    = try(oauth2_permission_scope.value.enabled, true)
          type                       = oauth2_permission_scope.value.type
          user_consent_description   = oauth2_permission_scope.value.user_consent_description
          user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
          value                      = oauth2_permission_scope.value.value
        }
      }
    }
  }

  dynamic "app_role" {
    for_each = coalesce(var.registration.app_roles, {})

    content {
      allowed_member_types = app_role.value.allowed_member_types
      description          = app_role.value.description
      display_name         = app_role.value.display_name
      id                   = app_role.value.id
      enabled              = try(app_role.value.enabled, true)
      value                = app_role.value.value
    }
  }

  dynamic "feature_tags" {
    for_each = var.registration.feature_tags != null ? { this = {} } : {}

    content {
      custom_single_sign_on = var.registration.feature_tags.custom_single_sign_on
      enterprise            = var.registration.feature_tags.enterprise
      gallery               = var.registration.feature_tags.gallery
      hide                  = var.registration.feature_tags.hide
    }
  }

  dynamic "optional_claims" {
    for_each = var.registration.optional_claims != null ? { this = {} } : {}

    content {
      dynamic "access_token" {
        for_each = coalesce(var.registration.optional_claims.access_token, {})

        content {
          name                  = coalesce(access_token.value.name, access_token.key)
          additional_properties = access_token.value.additional_properties
          essential             = access_token.value.essential
          source                = access_token.value.source
        }
      }

      dynamic "id_token" {
        for_each = coalesce(var.registration.optional_claims.id_token, {})

        content {
          name                  = coalesce(id_token.value.name, id_token.key)
          additional_properties = id_token.value.additional_properties
          essential             = id_token.value.essential
          source                = id_token.value.source
        }
      }

      dynamic "saml2_token" {
        for_each = coalesce(var.registration.optional_claims.saml2_token, {})

        content {
          name                  = coalesce(saml2_token.value.name, saml2_token.key)
          additional_properties = saml2_token.value.additional_properties
          essential             = saml2_token.value.essential
          source                = saml2_token.value.source
        }
      }
    }
  }

  dynamic "public_client" {
    for_each = var.registration.public_client != null ? { this = {} } : {}

    content {
      redirect_uris = var.registration.public_client.redirect_uris
    }
  }

  dynamic "required_resource_access" {
    for_each = coalesce(var.registration.required_resource_accesses, {})

    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_accesses

        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }

  dynamic "single_page_application" {
    for_each = var.registration.single_page_application != null ? { this = {} } : {}

    content {
      redirect_uris = var.registration.single_page_application.redirect_uris
    }
  }

  dynamic "web" {
    for_each = var.registration.web != null ? { this = {} } : {}

    content {
      homepage_url  = var.registration.web.homepage_url
      logout_url    = var.registration.web.logout_url
      redirect_uris = var.registration.web.redirect_uris

      dynamic "implicit_grant" {
        for_each = var.registration.web.implicit_grant != null ? { this = {} } : {}

        content {
          access_token_issuance_enabled = var.registration.web.implicit_grant.access_token_issuance_enabled
          id_token_issuance_enabled     = var.registration.web.implicit_grant.id_token_issuance_enabled
        }
      }
    }
  }
}

# pre-authorized applications
resource "azuread_application_pre_authorized" "this" {
  for_each = coalesce(var.registration.pre_authorized_applications, {})

  application_id       = azuread_application.this.id
  authorized_client_id = each.value.authorized_client_id
  permission_ids       = each.value.permission_ids
}

# service principal
resource "azuread_service_principal" "this" {
  for_each = var.registration.service_principal != null ? { this = {} } : {}

  client_id                     = azuread_application.this.client_id
  account_enabled               = try(var.registration.service_principal.account_enabled, true)
  alternative_names             = var.registration.service_principal.alternative_names
  app_role_assignment_required  = var.registration.service_principal.app_role_assignment_required
  description                   = var.registration.service_principal.description
  login_url                     = var.registration.service_principal.login_url
  notes                         = var.registration.service_principal.notes
  notification_email_addresses  = var.registration.service_principal.notification_email_addresses
  owners                        = var.registration.service_principal.owners
  preferred_single_sign_on_mode = var.registration.service_principal.preferred_single_sign_on_mode
  tags                          = var.registration.service_principal.tags
  use_existing                  = var.registration.service_principal.use_existing

  dynamic "feature_tags" {
    for_each = var.registration.service_principal.feature_tags != null ? { this = {} } : {}

    content {
      custom_single_sign_on = var.registration.service_principal.feature_tags.custom_single_sign_on
      enterprise            = var.registration.service_principal.feature_tags.enterprise
      gallery               = var.registration.service_principal.feature_tags.gallery
      hide                  = var.registration.service_principal.feature_tags.hide
    }
  }

  dynamic "saml_single_sign_on" {
    for_each = var.registration.service_principal.saml_single_sign_on != null ? { this = {} } : {}

    content {
      relay_state = var.registration.service_principal.saml_single_sign_on.relay_state
    }
  }
}
