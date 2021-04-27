output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks1.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks1.kube_config_raw
}

output "identity_principal" {
  value = azurerm_kubernetes_cluster.aks1.identity[0].principal_id
}

output "identity_tenant" {
  value = azurerm_kubernetes_cluster.aks1.identity[0].tenant_id
}
