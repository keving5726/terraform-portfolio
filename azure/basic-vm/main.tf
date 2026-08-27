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

resource "azurerm_subnet" "internal" {
  name                 = "snet-${local.prefix}-001"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${local.prefix}-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Dynamic"
  }
}
