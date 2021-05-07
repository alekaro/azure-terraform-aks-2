resource "azurerm_role_assignment" "ra1" {
    scope                   = module.vnet-main.vnet_subnets[1]
    role_definition_name    = "Network Contributor"
    principal_id            = azurerm_user_assigned_identity.aks_identity_1.principal_id
    depends_on              = [module.vnet-main, module.aks-cluster, azurerm_user_assigned_identity.aks_identity_1]
}

# resource "azurerm_role_assignment" "ra2" {    # It is not needed as we pass user_assigned_identity_id to the aks-cluster and we don't use service_principal
#   scope                = azurerm_user_assigned_identity.aks_identity.id
#   role_definition_name = "Managed Identity Operator"
#   principal_id         = azuread_service_principal.sp1.id
#   depends_on           = [azurerm_user_assigned_identity.aks_identity]
# }

resource "azurerm_role_assignment" "ra3" {
  scope                = module.gateway.gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity_1.principal_id
  depends_on           = [azurerm_user_assigned_identity.aks_identity_1, module.gateway]
}

resource "azurerm_role_assignment" "ra4" {
  scope                = azurerm_resource_group.cluster-rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_identity_1.principal_id
  depends_on           = [module.aks-cluster, azurerm_user_assigned_identity.aks_identity_1]
}

resource "azurerm_role_assignment" "ra5" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity_1.principal_id
  depends_on           = [module.aks-cluster, azurerm_user_assigned_identity.aks_identity_1]
}

resource "azurerm_role_assignment" "ra6" {
  scope                = var.container_registry_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity_1.principal_id
  depends_on           = [module.aks-cluster, azurerm_user_assigned_identity.aks_identity_1]
}