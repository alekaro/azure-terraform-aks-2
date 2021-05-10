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
    gateway_id              = module.gateway.gateway_id
    node_count              = 1
    subnet_id               = module.vnet-main.vnet_subnets[1] # cluster
    enable_rbac             = true
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity_1.id

    depends_on              = [azurerm_resource_group.cluster-rg, azurerm_user_assigned_identity.aks_identity_1]
}

data "azurerm_subscription" "current" {
}

