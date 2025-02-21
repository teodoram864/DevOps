# We ask Terraform to show the values of some variables after execution

output "vm_ip" {
  value = azurerm_linux_virtual_machine.linuxvm.public_ip_address
}

output "ControlMachine_private_key" {
  value     = tls_private_key.cm_ssh.private_key_pem
  sensitive = true
}