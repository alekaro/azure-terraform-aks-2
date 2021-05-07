provider "azurerm"{
    features {}
}

module "asa" {
    source                  = "./ASA"
}

module "aks" {
    source                  = "./AKS-COPY"
    storage_account_id      = module.asa.storage_account_id
    container_registry_id   = module.asa.container_registry_id
    # storage_account_name    = module.asa.storage_account_name
    # storage_container_name  = module.asa.storage_container_name
    # container_registry_name = module.asa.container_registry_name
    # storage_rg_name         = module.asa.resource_group_name
    # storage_location        = module.asa.location

    depends_on              = [module.asa]
}
