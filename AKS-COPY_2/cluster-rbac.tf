resource "azurerm_role_assignment" "ra0" {
    scope                   = "${data.azurerm_subscription.current.id}/resourcegroups/${module.aks-cluster.node_resource_group}"
    role_definition_name    = "Managed Identity Operator"
    principal_id            = module.aks-cluster.identity_principal_id
    depends_on              = [module.vnet-main, module.aks-cluster]
}

resource "azurerm_role_assignment" "ra1" {
    scope                   = module.vnet-main.vnet_subnets[1]
    role_definition_name    = "Network Contributor"
    principal_id            = module.aks-cluster.identity_principal_id
    depends_on              = [module.vnet-main, module.aks-cluster]
}

resource "azurerm_role_assignment" "ra3" {
  scope                = module.gateway.gateway_id
  role_definition_name = "Contributor"
  principal_id         = module.aks-cluster.identity_principal_id
  depends_on           = [module.gateway]
}

resource "azurerm_role_assignment" "ra4" {
  scope                = azurerm_resource_group.cluster-rg.id
  role_definition_name = "Reader"
  principal_id         = module.aks-cluster.identity_principal_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra5" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.aks-cluster.identity_principal_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra6" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.aks-cluster.kubelet_identity_object_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra7" {
  scope                = var.container_registry_id
  role_definition_name = "Contributor"
  principal_id         = module.aks-cluster.identity_principal_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra8" {
  scope                = var.container_registry_id
  role_definition_name = "Contributor"
  principal_id         = module.aks-cluster.kubelet_identity_object_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra10" {
  scope                = "${data.azurerm_subscription.current.id}/resourcegroups/${module.aks-cluster.node_resource_group}"
  role_definition_name = "Contributor"
  principal_id         = module.aks-cluster.kubelet_identity_object_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra11" {
  scope                = "${data.azurerm_subscription.current.id}/resourcegroups/${module.aks-cluster.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.aks-cluster.identity_principal_id
  depends_on           = [module.aks-cluster]

}

resource "azurerm_role_assignment" "ra12" {
  scope                = "${data.azurerm_subscription.current.id}/resourcegroups/${module.aks-cluster.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.aks-cluster.kubelet_identity_object_id
  depends_on           = [module.aks-cluster]

}

resource "azurerm_role_assignment" "ra13" {
  scope                = azurerm_resource_group.cluster-rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks-cluster.kubelet_identity_object_id
  depends_on           = [module.aks-cluster]
}

resource "azurerm_role_assignment" "ra14" {
  scope                = "${data.azurerm_subscription.current.id}/resourcegroups/${module.aks-cluster.node_resource_group}"
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks-cluster.kubelet_identity_object_id
  depends_on           = [module.aks-cluster]
}
