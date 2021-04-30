output "subscription_id" {
    value   = data.azurerm_subscription.current.id
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

# output "kube_config_raw" {
#     value   = module.aks-cluster.kube_config_raw
# }

output "identity_resource_id" {
    value = azurerm_user_assigned_identity.aks_identity.id
}

output "identity_client_id" {
    value = azurerm_user_assigned_identity.aks_identity.client_id
}