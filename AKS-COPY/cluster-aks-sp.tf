# resource "azuread_application" "app1" {
#     display_name               = "${var.prefix}-aks-app"
# }

# resource "azuread_service_principal" "sp1" {
#     application_id               = azuread_application.app1.application_id
# }

# resource "azuread_service_principal_password" "secret1" {
#     service_principal_id = azuread_service_principal.sp1.id
#     value                = "v_fHS7~51925vMiz0.RfZ-2QsJ-WK1FNMF"
#     end_date             = "2022-01-01T01:02:03Z"
# }