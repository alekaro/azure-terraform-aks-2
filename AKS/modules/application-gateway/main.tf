resource "azurerm_public_ip" "gw_ip" {
  name                = "${var.prefix}-gw-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

locals {
    gateway_ip_configuration_name   = "${var.prefix}-gic"
    backend_address_pool_name       = "${var.prefix}-beap"
    frontend_port_name              = "${var.prefix}-feport"
    frontend_ip_configuration_name  = "${var.prefix}-feip"
    http_setting_name               = "${var.prefix}-be-htst"
    listener_name                   = "${var.prefix}-be-htst"
    request_routing_rule_name       = "${var.prefix}-rqrt"
    redirect_configuration_name     = "${var.prefix}-rdcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.prefix}-gw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.subnet_id # gateway subnet
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.gw_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}