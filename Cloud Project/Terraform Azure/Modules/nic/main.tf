resource "azurerm_network_interface" "nic" {
  count                = length(var.nic_names)
  name                 = var.nic_names[count.index]
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
   
   public_ip_address_id = var.nic_names[count.index] == "nic-front" ? var.public_ip_address_id : null
  }
}
