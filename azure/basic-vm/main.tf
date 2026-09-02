locals {
  prefix = "${var.project}-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}-001"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["172.16.0.0/16"]
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
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_security_group" "ssh" {
  name                = "nsg-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  security_rule {
    name                       = "default-allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                = "vm-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.size
  admin_username      = var.username

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = file("${var.public_key}")
  }

  os_disk {
    caching              = var.disk_configuration.caching
    storage_account_type = var.disk_configuration.storage_account_type
  }

  source_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.os_image.sku
    version   = var.os_image.version
  }
}
