# application registration
resource "azuread_application" "this" {
  display_name                   = var.config.display_name
  description                    = var.config.description
  sign_in_audience               = var.config.sign_in_audience
  identifier_uris                = var.config.identifier_uris
  group_membership_claims        = var.config.group_membership_claims
  owners                         = var.config.owners
  device_only_auth_enabled       = var.config.device_only_auth_enabled
  fallback_public_client_enabled = var.config.fallback_public_client_enabled
  logo_image                     = var.config.logo_image
  marketing_url                  = var.config.marketing_url
  notes                          = var.config.notes
  oauth2_post_response_required  = var.config.oauth2_post_response_required
  prevent_duplicate_names        = var.config.prevent_duplicate_names
  privacy_statement_url          = var.config.privacy_statement_url
  service_management_reference   = var.config.service_management_reference
  support_url                    = var.config.support_url
  tags                           = var.config.tags
  template_id                    = var.config.template_id
  terms_of_service_url           = var.config.terms_of_service_url

  dynamic "password" {
    for_each = var.config.password != null ? { this = {} } : {}

    content {
      display_name = var.config.password.display_name
      end_date     = var.config.password.end_date
      start_date   = var.config.password.start_date
    }
  }

  dynamic "api" {
    for_each = var.config.api != null ? { this = {} } : {}

    content {
      known_client_applications      = var.config.api.known_client_applications
      mapped_claims_enabled          = var.config.api.mapped_claims_enabled
      requested_access_token_version = var.config.api.requested_access_token_version

      dynamic "oauth2_permission_scope" {
        for_each = coalesce(var.config.api.oauth2_permission_scopes, {})

        content {
          id                         = oauth2_permission_scope.value.id
          admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
          admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
          enabled                    = oauth2_permission_scope.value.enabled
          type                       = oauth2_permission_scope.value.type
          user_consent_description   = oauth2_permission_scope.value.user_consent_description
          user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
          value                      = oauth2_permission_scope.value.value
        }
      }
    }
  }

  dynamic "app_role" {
    for_each = coalesce(var.config.app_roles, {})

    content {
      allowed_member_types = app_role.value.allowed_member_types
      description          = app_role.value.description
      display_name         = app_role.value.display_name
      id                   = app_role.value.id
      enabled              = app_role.value.enabled
      value                = app_role.value.value
    }
  }

  dynamic "feature_tags" {
    for_each = var.config.feature_tags != null ? { this = {} } : {}

    content {
      custom_single_sign_on = var.config.feature_tags.custom_single_sign_on
      enterprise            = var.config.feature_tags.enterprise
      gallery               = var.config.feature_tags.gallery
      hide                  = var.config.feature_tags.hide
    }
  }

  dynamic "optional_claims" {
    for_each = var.config.optional_claims != null ? { this = {} } : {}

    content {
      dynamic "access_token" {
        for_each = coalesce(var.config.optional_claims.access_token, {})

        content {
          name                  = coalesce(access_token.value.name, access_token.key)
          additional_properties = access_token.value.additional_properties
          essential             = access_token.value.essential
          source                = access_token.value.source
        }
      }

      dynamic "id_token" {
        for_each = coalesce(var.config.optional_claims.id_token, {})

        content {
          name                  = coalesce(id_token.value.name, id_token.key)
          additional_properties = id_token.value.additional_properties
          essential             = id_token.value.essential
          source                = id_token.value.source
        }
      }

      dynamic "saml2_token" {
        for_each = coalesce(var.config.optional_claims.saml2_token, {})

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
    for_each = var.config.public_client != null ? { this = {} } : {}

    content {
      redirect_uris = var.config.public_client.redirect_uris
    }
  }

  dynamic "required_resource_access" {
    for_each = coalesce(var.config.required_resource_accesses, {})

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
    for_each = var.config.single_page_application != null ? { this = {} } : {}

    content {
      redirect_uris = var.config.single_page_application.redirect_uris
    }
  }

  dynamic "web" {
    for_each = var.config.web != null ? { this = {} } : {}

    content {
      homepage_url  = var.config.web.homepage_url
      logout_url    = var.config.web.logout_url
      redirect_uris = var.config.web.redirect_uris

      dynamic "implicit_grant" {
        for_each = var.config.web.implicit_grant != null ? { this = {} } : {}

        content {
          access_token_issuance_enabled = var.config.web.implicit_grant.access_token_issuance_enabled
          id_token_issuance_enabled     = var.config.web.implicit_grant.id_token_issuance_enabled
        }
      }
    }
  }
}

# pre-authorized applications
resource "azuread_application_pre_authorized" "this" {
  for_each = coalesce(var.config.pre_authorized_applications, {})

  application_id       = azuread_application.this.id
  authorized_client_id = each.value.authorized_client_id
  permission_ids       = each.value.permission_ids
}

# service principal
resource "azuread_service_principal" "this" {
  for_each = var.config.service_principal != null ? { this = {} } : {}

  client_id                     = azuread_application.this.client_id
  account_enabled               = var.config.service_principal.account_enabled
  alternative_names             = var.config.service_principal.alternative_names
  app_role_assignment_required  = var.config.service_principal.app_role_assignment_required
  description                   = var.config.service_principal.description
  login_url                     = var.config.service_principal.login_url
  notes                         = var.config.service_principal.notes
  notification_email_addresses  = var.config.service_principal.notification_email_addresses
  owners                        = var.config.service_principal.owners
  preferred_single_sign_on_mode = var.config.service_principal.preferred_single_sign_on_mode
  tags                          = var.config.service_principal.tags
  use_existing                  = var.config.service_principal.use_existing

  dynamic "feature_tags" {
    for_each = var.config.service_principal.feature_tags != null ? { this = {} } : {}

    content {
      custom_single_sign_on = var.config.service_principal.feature_tags.custom_single_sign_on
      enterprise            = var.config.service_principal.feature_tags.enterprise
      gallery               = var.config.service_principal.feature_tags.gallery
      hide                  = var.config.service_principal.feature_tags.hide
    }
  }

  dynamic "saml_single_sign_on" {
    for_each = var.config.service_principal.saml_single_sign_on != null ? { this = {} } : {}

    content {
      relay_state = var.config.service_principal.saml_single_sign_on.relay_state
    }
  }
}
