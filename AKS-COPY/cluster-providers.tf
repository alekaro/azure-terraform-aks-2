# provider "azurerm" {
#     features {}
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.aks-cluster.kube_config.0.host
#     client_certificate     = "${base64decode(module.aks-cluster.kube_config.0.client_certificate)}"
#     client_key             = "${base64decode(module.aks-cluster.kube_config.0.client_key)}"
#     cluster_ca_certificate = "${base64decode(module.aks-cluster.kube_config.0.cluster_ca_certificate)}"
#   }
# }