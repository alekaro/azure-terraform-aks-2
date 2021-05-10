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

output "user_assigned_identity_id" {
  value = azurerm_user_assigned_identity.aks_identity_1.id
}

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_identity_1.client_id
}

output "kubelet_identity_object_id" {
  value = module.aks-cluster.kubelet_identity_object_id
}

output "kubelet_identity_client_id" {
  value = module.aks-cluster.kubelet_identity_client_id
}

output "kubelet_identity_user_assigned_identity_id" {
  value = module.aks-cluster.kubelet_identity_user_assigned_identity_id
}

output "full_kubelet_identity" {
  value = module.aks-cluster.full_kubelet_identity
}

output "full_identity" {
  value = module.aks-cluster.full_identity
}