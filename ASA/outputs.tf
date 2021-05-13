output "storage_account_id" {
    value = azurerm_storage_account.sa1.id
}

output "storage_account_name" {
    value = azurerm_storage_account.sa1.name
}

output "storage_container_name" {
    value = azurerm_storage_container.ct1.name
}

output "container_registry_id" {
    value = azurerm_container_registry.acr1.id
}

output "container_registry_name" {
    value = azurerm_container_registry.acr1.name
}

output "resource_group_name" {
    value = azurerm_resource_group.storage-rg.name
}

output "location" {
    value = azurerm_resource_group.storage-rg.location
}