provider "azurerm" {
    features {}
}

module "gateway" {
    source                  = "./modules/application-gateway"
    prefix                  = var.prefix
    resource_group_name     = var.resource_group_name
    location                = var.location
    subnet_id               = module.vnet-main.vnet_subnets[0] # gateway

    depends_on              = [azurerm_resource_group.cluster-rg]
}

module "aks-cluster" {
    source                  = "./modules/aks-cluster"
    prefix                  = var.prefix
    resource_group_name     = var.resource_group_name
    location                = var.location
    node_count              = 1
    subnet_id               = module.vnet-main.vnet_subnets[1] # cluster
    enable_rbac             = true

    depends_on              = [azurerm_resource_group.cluster-rg]
}

# resource "azurerm_user_assigned_identity" "aks-identity" {
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location

#   name = "${var.prefix}-aks-identity"
# }

data "azurerm_subscription" "current" {
}

# User Assigned Identities 
# resource "azurerm_user_assigned_identity" "aks_identity" {
#   resource_group_name = var.resource_group_name
#   location            = var.location

#   name = "cluster-aks-identity"
# }

# resource "azurerm_role_assignment" "ra1" {
#   scope                = data.azurerm_subnet.kubesubnet.id
#   role_definition_name = "Network Contributor"
#   principal_id         = var.aks_service_principal_object_id 

#   depends_on = [azurerm_virtual_network.test]
# }

resource "azurerm_role_assignment" "ra1" {
    scope                   = module.vnet-main.vnet_subnets[1]
    role_definition_name    = "Network Contributor"
    principal_id            = module.aks-cluster.identity_principal
    depends_on              = [module.aks-cluster]
}

# resource "azurerm_role_assignment" "ra2" {
#   scope                = azurerm_user_assigned_identity.aks_identity.id
#   role_definition_name = "Managed Identity Operator"
#   principal_id         = var.aks_service_principal_object_id
#   depends_on           = [azurerm_user_assigned_identity.aks_identity]
# }

resource "azurerm_role_assignment" "ra2" {
  scope                = module.gateway.gateway_id
  role_definition_name = "Contributor"
  principal_id         = module.aks-cluster.identity_principal
  depends_on           = [module.aks-cluster, module.gateway]
}

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_resource_group.cluster-rg.id
  role_definition_name = "Reader"
  principal_id         = module.aks-cluster.identity_principal
  depends_on           = [module.aks-cluster, module.gateway]
}
