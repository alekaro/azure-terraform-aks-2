resource "azurerm_container_registry" "acr1" {
  name                     = "${var.prefix}${random_integer.storage_rnd.result}acr"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "Basic"
  admin_enabled            = false

  depends_on          = [azurerm_resource_group.storage-rg]
}