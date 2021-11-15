locals {
  prefix              = "${var.product}-bootstrap-${var.env}"
  resource_group_name = "${local.prefix}-rg"
  key_vault_name      = "${local.prefix}-kv"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

data "azurerm_user_assigned_identity" "jenkins_ptl_mi" {
  provider            = azurerm.ptl
  name                = "jenkins-ptl-mi"
  resource_group_name = "managed-identities-ptl-rg"
}

module "kv" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = data.azurerm_client_config.current.tenant_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}


resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = module.kv.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_user_assigned_identity.jenkins_ptl_mi.principal_id
  key_permissions         = []
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
  certificate_permissions = []
  storage_permissions     = []
}