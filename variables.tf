variable "azure_identity_name" {
    type    = string
    default = "azure-identity-test"
}

variable "azure_identity_binding_name" {
    type    = string
    default = "azure-identity-binding-test"
}

variable "selector" {
    type    = string
    default = "aad_pod_selector"
}

variable "azure_identity_file_name" {
    type    = string
    default = "azureidentity_deploy"
}

variable "azure_identity_binding_file_name" {
    type    = string
    default = "azureidentitybinding_deploy"
}

variable "image_deploy_script_name" {
    type    = string
    default = "image_deploy"
}

variable "init_script_name" {
    type    = string
    default = "init_script"
}

variable "storage_content_push_script_name" {
    type    = string
    default = "push_to_storage"
}

variable "deployment_file_name" {
    type    = string
    default = "autoscaler_deployment"
}