output "registration" {
  description = "contains app registration configuration"
  value       = azuread_application.this
}

output "pre_authorized_applications" {
  description = "contains all pre-authorized application configurations"
  value       = azuread_application_pre_authorized.this
}

output "service_principal" {
  description = "contains service principal configuration"
  value       = try(azuread_service_principal.this["this"], null)
}
