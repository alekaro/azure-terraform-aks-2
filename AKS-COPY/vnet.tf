module "vnet-main" {
    source                  = "Azure/vnet/azurerm"
    resource_group_name     = var.resource_group_name
    vnet_name               = "${var.resource_group_name}-vnet"
    address_space           = var.vnet_cidr_range
    subnet_prefixes         = var.vnet_subnet_prefixes
    subnet_names            = var.vnet_subnet_names
    nsg_ids                 = {}

    depends_on              = [azurerm_resource_group.cluster-rg]
}