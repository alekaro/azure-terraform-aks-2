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

variable "storage_account_id" {
    type    = string
}

variable "container_registry_id" {
    type    = string
}
