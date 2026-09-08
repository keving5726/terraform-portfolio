locals {
  prefix = "${var.project}-${var.environment}-${var.location}"

  default_tags = {
    project     = var.project
    environment = var.environment
    owner       = var.owner
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}-001"
  location = var.location

  tags = local.default_tags
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["172.16.0.0/16"]

  tags = local.default_tags
}

resource "azurerm_subnet" "internal" {
  name                 = "snet-${local.prefix}-001"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "pip-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = local.default_tags
}

resource "azurerm_lb" "external" {
  name                = "lbe-${local.prefix}-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = "bepool"
  loadbalancer_id = azurerm_lb.external.id
}

resource "azurerm_lb_probe" "http" {
  name                = "http-running-probe"
  loadbalancer_id     = azurerm_lb.external.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "http" {
  name                           = "rule-${local.prefix}-001"
  loadbalancer_id                = azurerm_lb.external.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.http.id
  disable_outbound_snat          = true
}

resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "natrule-${local.prefix}-001"
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.external.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50100
  backend_port                   = 22
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
}
