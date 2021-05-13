variable "prefix" {
    type    = string
    default = "cluster"
}

variable "resource_group_name" {
    type    = string
    default = "cluster-rg"
}

variable "location" {
    type    = string
    default = "westeurope"
}

# variable "aks_service_principal_app_id" {
#     description = "Application ID/Client ID  of the service principal. Used by AKS to manage AKS related resources on Azure like vms, subnets. https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#authentication-two-options"
#     default     = "4ca15151-4c01-4075-8b5a-dd1e7eccdcc1"
# }

# variable "aks_service_principal_client_secret" {
#     description = "Secret of the service principal. Used by AKS to manage Azure."
#     default     = "v_fHS7~51925vMiz0.RfZ-2QsJ-WK1FNMF"
# }

# variable "aks_service_principal_object_id" {
#     description = "Object ID of the service principal. (az ad sp show --id <app_id>)"
#     default     = "6e413782-7820-4734-a1f8-e67b248574c1"
# }

variable "vnet_cidr_range" {
    type    = list(string)
    default = ["10.1.0.0/16"]
}

variable "vnet_subnet_prefixes" {
    type    = list(string)
    default = ["10.1.0.0/24", "10.1.1.0/24"]
}

variable "vnet_subnet_names" {
    type    = list(string)
    default = ["gateway", "cluster"]
}