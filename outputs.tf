output "pod_label_selector" {
    value   = "${var.selector}"
}

output "storage_account_id" {
    value = module.asa.storage_account_id
}

output "storage_account_name" {
    value = module.asa.storage_account_name
}

output "storage_container_name" {
    value = module.asa.storage_container_name
}

output "container_registry_name" {
    value = module.asa.container_registry_name
}

output "cluster_msi_client_id" {
  value = module.aks.cluster_msi_client_id
}