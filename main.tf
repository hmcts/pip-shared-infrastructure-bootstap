locals {
  prefix              = "${var.product}-bootstrap-${var.env}"
  resource_group_name = "${local.prefix}-rg"
  key_vault_name      = "${local.prefix}-kv"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}
data "azurerm_client_config" "current" {}

data "azurerm_user_assigned_identity" "jenkins" {
  name                = "jenkins-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "kv" {
  source                   = "git@github.com:hmcts/cnp-module-key-vault?ref=DTSPO-31965/remove-jenkins-ptl-access"
  name                     = local.key_vault_name
  product                  = var.product
  env                      = var.env
  object_id                = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
  jenkins_object_id        = data.azurerm_user_assigned_identity.jenkins.principal_id
  grant_dev_jenkins_access = var.env == "stg"
  resource_group_name      = azurerm_resource_group.rg.name
  product_group_name       = var.active_directory_group
  common_tags              = var.common_tags
  developers_group         = "DTS PIP Non-Prod"
  create_managed_identity  = false
}
