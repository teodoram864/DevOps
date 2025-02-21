# We use this file to define providers

provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7"
    }
  }
}

