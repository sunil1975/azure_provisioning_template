terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # use the latest stable version
    }

  }
}
provider "azurerm" {
  features {}
}