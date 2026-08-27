locals {
  prefix = "${var.namespace}-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}-001"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.prefix}-001"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
