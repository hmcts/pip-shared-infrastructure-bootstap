terraform {
  backend "azurerm" {}

  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      version = "4.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}
