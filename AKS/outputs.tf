output "subscription_id" {
    value   = data.azurerm_subscription.current.id
}

output "aks_identity_principal" {
    value   = module.aks-cluster.identity_principal
}

output "aks_identity_tenant" {
    value   = module.aks-cluster.identity_tenant
}

output "gateway_id" {
    value   = module.gateway.gateway_id
}

output "gateway_name" {
    value   = module.gateway.gateway_name
}

output "resource_group_name" {
    value   = var.resource_group_name
}

output "kube_config" {
    value   = module.aks-cluster.kube_config
}