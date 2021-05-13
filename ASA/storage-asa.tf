resource "azurerm_storage_account" "sa1" {
  name                     = "${var.prefix}${random_integer.storage_rnd.result}sa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }

  depends_on               = [azurerm_resource_group.storage-rg]
}

resource "azurerm_storage_container" "ct1" {
  name                  = "asa-container"
  storage_account_name  = azurerm_storage_account.sa1.name
  container_access_type = "private"
}