variable "prefix" {
    type    = string
}

variable "resource_group_name" {
    type    = string
}

variable "location" {
    type    = string
}

variable "client_id" {
    description = "Application ID/Client ID  of the service principal. Used by AKS to manage AKS related resources on Azure like vms, subnets."
}

variable "client_secret" {
    description = "Secret of the service principal. Used by AKS to manage Azure."
}

variable "node_count" {
    type    = number
    default = 1
}

variable "subnet_id" {
    type    = string
}

variable "enable_rbac" {
    type    = bool
}