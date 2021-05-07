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

output "identity_principal_id" {
  value = azurerm_kubernetes_cluster.aks1.identity[0].principal_id
}

output "full_kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks1.kubelet_identity
}

output "full_identity" {
  value = azurerm_kubernetes_cluster.aks1.identity
}

# output "user_assigned_identity_id_test" {
#   value = azurerm_user_assigned_identity.aks_identity_1.id
# }
