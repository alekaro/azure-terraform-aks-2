output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks1.kube_config.0.client_certificate
}

output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.aks1.kube_config_raw
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks1.kube_config
}

output "name" {
  value = azurerm_kubernetes_cluster.aks1.name
}

output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks1.kubelet_identity[0].object_id
}

output "kubelet_identity_client_id" {
  value = azurerm_kubernetes_cluster.aks1.kubelet_identity[0].client_id
}

output "kubelet_identity_user_assigned_identity_id" {
  value = azurerm_kubernetes_cluster.aks1.kubelet_identity[0].user_assigned_identity_id
}

output "identity_principal_id" {
  value = azurerm_kubernetes_cluster.aks1.identity[0].principal_id
}

output "identity_tenant_id" {
  value = azurerm_kubernetes_cluster.aks1.identity[0].tenant_id
}

output "full_kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks1.kubelet_identity
}

output "full_identity" {
  value = azurerm_kubernetes_cluster.aks1.identity
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks1.node_resource_group
}