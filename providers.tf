terraform {
  backend "azurerm" {}

  required_version = ">= 1.0.4"
  required_providers {
    azurerm = {
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  features {}
  alias           = "ptl"
  subscription_id = "6c4d2513-a873-41b4-afdd-b05a33206631"
}