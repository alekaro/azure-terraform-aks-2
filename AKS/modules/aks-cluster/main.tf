resource "azurerm_kubernetes_cluster" "aks1" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-aks-dns"

  default_node_pool {
    name            = "${var.prefix}aksnp"
    node_count      = var.node_count
    vm_size         = "Standard_D2_v2"

    vnet_subnet_id  = var.subnet_id
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
    # ingress_application_gateway {   # Not yet implemented (probably in terraform version 0.16)
    #   enabled     = true
    #   gateway_id  = var.gateway_id
    # }
  }

  network_profile {
      network_plugin = "azure"
  }

  # service_principal {
  #   client_id       = var.client_id
  #   client_secret   = var.client_secret
  # }

  identity {
    type                        = "UserAssigned"
    user_assigned_identity_id   = var.user_assigned_identity_id
  }


  role_based_access_control {
    enabled = var.enable_rbac
  }

}