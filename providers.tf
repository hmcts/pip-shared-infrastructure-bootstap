terraform {
  backend "azurerm" {}

  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      version = "3.103.1"
    }
  }
}

provider "azurerm" {
  features {}
}
