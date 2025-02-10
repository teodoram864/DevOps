variable "nic_name" {
  description = "Nom de l'interface réseau"
  type        = string
}

variable "location" {
  description = "Emplacement Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "subnet_id" {
  description = "ID du sous-réseau auquel connecter la NIC"
  type        = string
}
