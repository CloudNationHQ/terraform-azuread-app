# App Registrations and Service Principals

This terraform module simplifies the creation and management of Azure AD app registration resources, providing customizable options for application configuration, API permissions, app roles, OAuth2 permission scopes, and service principal settings, all managed through code.

## Features

Capability to deploy app registrations with full control over sign-in audience and identifier URIs.

Includes support for OAuth2 permission scopes and pre-authorized client applications.

Supports app roles for role-based access control within applications.

Configurable web, SPA, and public client redirect URIs with implicit grant settings.

Optional claims configuration for access tokens, ID tokens, and SAML2 tokens.

Required resource access declarations for Microsoft Graph and other APIs.

Service principal creation with configurable assignment requirements and feature tags.

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 3.0)

## Resources

The following resources are used by this module:

- [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) (resource)
- [azuread_application_pre_authorized.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_pre_authorized) (resource)
- [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: contains app registration configuration

Type:

```hcl
object({
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
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_config"></a> [config](#output\_config)

Description: contains app registration configuration

### <a name="output_pre_authorized_applications"></a> [pre\_authorized\_applications](#output\_pre\_authorized\_applications)

Description: contains all pre-authorized application configurations

### <a name="output_service_principal"></a> [service\_principal](#output\_service\_principal)

Description: contains service principal configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make docs`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-aadapp/graphs/contributors).

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-aadapp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-aadapp" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/entra/identity-platform/app-objects-and-service-principals)
- [Rest Api](https://learn.microsoft.com/en-us/graph/api/resources/application)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/graphrbac)
