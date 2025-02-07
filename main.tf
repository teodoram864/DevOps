resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.resource_group_location
}

resource "azurerm_virtual_network" "vnet" {
    name = var.virtual_network_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/16"]  
}
resource "azurerm_subnet" "subnet1" {
    name = var.subnet_name_1
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "subnet2" {
    name = var.subnet_name_2
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "public_ip" {
    name = var.public_ip_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Dynamic"
}
resource "azurerm_network_security_group" "nsg" {
    name = var.network_security_group_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location

    security_rule {
        name = "SSH"
        priority = 1000
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "nic1" {
    name = var.network_interface_name_1
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location

    ip_configuration {
        name = "NicConfigurationFront"
        subnet_id = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.public_ip.id
    }
}
resource "azurerm_network_interface" "nic2" {
    name = var.network_interface_name_2
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location

    ip_configuration {
        name = "NicConfigurationBack"
        subnet_id = azurerm_subnet.subnet2.id
        private_ip_address_allocation = "Dynamic"
    }
}
resource "tls_private_key" "ssh_1" {
    algorithm = "RSA"
    rsa_bits = 4096
}
resource "tls_private_key" "ssh_2" {
    algorithm = "RSA"
    rsa_bits = 4096
}
resource "azurerm_linux_virtual_machine" "linuxvm1" {
    name = var.linux_virtual_machine_name_1
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    network_interface_ids = [azurerm_network_interface.nic1.id]
    size = "Standard_DS1_v2"

    os_disk {
        name = "OSDiscFront"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }

    computer_name = "vmfront"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username = "azureuser"
        public_key = tls_private_key.ssh_1.public_key_openssh
    }
}
resource "azurerm_linux_virtual_machine" "linuxvm2" {
    name = var.linux_virtual_machine_name_2
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    network_interface_ids = [azurerm_network_interface.nic2.id]
    size = "Standard_DS1_v2"

    os_disk {
        name = "OSDiscback"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }

    computer_name = "vmback"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username = "azureuser"
        public_key = tls_private_key.ssh_2.public_key_openssh
    }
}