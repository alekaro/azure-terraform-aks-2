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

resource "azuread_application" "app1" {
    display_name               = "${var.prefix}-aks-app"
}

resource "azuread_service_principal" "sp1" {
    application_id               = azuread_application.app1.application_id
}

resource "azuread_service_principal_password" "secret1" {
    service_principal_id = azuread_service_principal.sp1.id
    value                = "v_fHS7~51925vMiz0.RfZ-2QsJ-WK1FNMF"
    end_date             = "2022-01-01T01:02:03Z"
}

module "aks-cluster" {
    source                  = "./modules/aks-cluster"
    prefix                  = var.prefix
    resource_group_name     = var.resource_group_name
    location                = var.location
    client_id               = azuread_application.app1.application_id
    client_secret           = azuread_service_principal_password.secret1.value
    node_count              = 1
    subnet_id               = module.vnet-main.vnet_subnets[1] # cluster
    enable_rbac             = true

    depends_on              = [azurerm_resource_group.cluster-rg, azuread_service_principal_password.secret1]
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = azurerm_resource_group.cluster-rg.name
  location            = azurerm_resource_group.cluster-rg.location

  name = "${var.prefix}-aks-identity"
}

data "azurerm_subscription" "current" {
}

resource "azurerm_role_assignment" "ra1" {
    scope                   = module.vnet-main.vnet_subnets[1]
    role_definition_name    = "Network Contributor"
    principal_id            = azuread_service_principal.sp1.id
    depends_on              = [module.vnet-main]
}

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_user_assigned_identity.aks_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_service_principal.sp1.id
  depends_on           = [azurerm_user_assigned_identity.aks_identity]
}

resource "azurerm_role_assignment" "ra3" {
  scope                = module.gateway.gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.aks_identity, module.gateway]
}

resource "azurerm_role_assignment" "ra4" {
  scope                = azurerm_resource_group.cluster-rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.aks_identity, module.gateway]
}
