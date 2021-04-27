variable "prefix" {
    type    = string
}

variable "resource_group_name" {
    type    = string
}

variable "location" {
    type    = string
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