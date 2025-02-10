
# output "vmfront_ip" {
#     value = azurerm_linux_virtual_machine.linuxvm1.public_ip_address
# }

# output "vmback_ip" {
#     value = azurerm_linux_virtual_machine.linuxvm2.private_ip_address
# }

output "PrivateKeyFront" {
    value = tls_private_key.ssh_1.private_key_pem
    sensitive = true
}

output "PrivateKeyBack" {
    value = tls_private_key.ssh_2.private_key_pem
    sensitive = true
}