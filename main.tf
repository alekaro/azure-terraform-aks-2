provider "azurerm"{
    features {}
}

module "asa" {
    source                  = "./ASA"
}

module "aks" {
    source                  = "./AKS-COPY_2"
    storage_account_id      = module.asa.storage_account_id
    container_registry_id   = module.asa.container_registry_id

    depends_on              = [module.asa]
}
