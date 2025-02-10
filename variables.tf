# variable "resource_group_name" {
#     type = string
#     description = "RG name in Azure"
# }

# variable  "resource_group_location" {
#   type        = string
#   description = "RG location in Azure"
# }

# variable "virtual_network_name" {
#   type        = string
#   description = "VNET name in Azure"
# }

# variable "subnet_name_1" {
#   type        = string
#   description = "Subnet for frontend inside the vNet"
# }

# variable "subnet_name_2" {
#   type        = string
#   description = "Subnet for backend inside the vNet"
# }

variable "public_ip_name" {
    type = string
    description = "Public IP for frontend in Azure"
    default = "front_public_ip"
}

# variable "network_security_group_name" {
#     type = string
#     description = "NSG name in Azure"
# }

variable "network_interface_name_1" {
    type = string
    description = "NIC name for front in Azure"
    default = "nic_front"
}

variable "network_interface_name_2" {
    type = string
    description = "NIC name for backend Azure"
    default = "nic_back"
}

# variable "linux_virtual_machine_name_1" {
#     type = string
#     description = "Linux VM frontend in Azure"
# }
# variable "linux_virtual_machine_name_2" {
#     type = string
#     description = "Linux VM backend in Azure"
# }
# variable tls_private_key_1 {
#   type        = string
#   description = "Private key for linuxvmfront"
# }
# variable tls_private_key_2 {
#   type        = string
#   description = "Private key for linuxvmback"
# }


    





