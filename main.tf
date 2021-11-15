locals {
  prefix               = "${var.product}-sharedservice-boot-${var.env}"
  resource_group_name  = "${local.prefix}-rg"
  key_vault_name       = "${local.prefix}-kv"
  env_long_name        = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "kv" {
  source                  = "git::https://github.com/hmcts/cnp-module-key-vault.git?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = data.azurerm_client_config.current.tenant_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}