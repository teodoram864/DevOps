# Create a resource group

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    envirement = "control"
  }
}

# Create a virtual network

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    envirement = "control"
  }
}

# Create a subnet

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IPs

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  tags = {
    envirement = "control"
  }
}

# Create a Network Security Group and Rule

resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    envirement = "control"
  }
}

# Create network interface

resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    envirement = "control"
  }
}

# Create the security group to the network interface

resource "azurerm_network_interface_security_group_association" "association" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  network_interface_id      = azurerm_network_interface.nic.id
}

# Generate a random text for a inique storage account name

resource "random_id" "randomId" {
  keepers = {
    # generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics

resource "azurerm_storage_account" "storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    envirement = "control"
  }
}

# Create (and display) an SSH key

resource "tls_private_key" "cm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = var.linux_virtual_machine_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "OSDiscCM"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name                   = "ControlMachine"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.cm_ssh.public_key_openssh
  }

  custom_data = filebase64("cloud-init.yaml")

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.cm_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  tags = {
    envirement = "control"
  }
}