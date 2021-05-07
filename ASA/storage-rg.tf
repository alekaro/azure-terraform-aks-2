resource "azurerm_resource_group" "storage-rg" {
    name         = var.resource_group_name
    location     = var.location
}