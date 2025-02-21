output "PrivateKeyFront" {
    value = tls_private_key.ssh_1.private_key_pem
    sensitive = true
}

output "PrivateKeyBack" {
    value = tls_private_key.ssh_2.private_key_pem
    sensitive = true
}

output "PrivateKeyMysql" {
    value = tls_private_key.ssh_3.private_key_pem
    sensitive = true
}