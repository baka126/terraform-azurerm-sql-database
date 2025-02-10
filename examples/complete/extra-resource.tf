resource "azurerm_resource_group" "this" {
  location = var.location
  name     = module.naming.resource_group.name
}

resource "random_id" "rg_name" {
  byte_length = 8
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  min_upper   = 1
}

module "naming" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  source  = "Azure/naming/azurerm"
  version = "0.4.0"

  prefix = ["test"]
  suffix = ["module"]
}

resource "azurerm_storage_account" "this" {
  # checkov:skip=CKV_AZURE_2: "Ensure that Storage Account is encrypted with Customer Managed Keys"
  # checkov:skip=CKV_AZURE_33: "Ensure Storage logging is enabled for Queue service for read, write and delete requests"
  # checkov:skip=CKV_AZURE_206: "Ensure that Storage Accounts use replication"
  # checkov:skip=CKV2_AZURE_38: "Ensure soft-delete is enabled on Azure storage account"
  # checkov:skip=CKV2_AZURE_33: "Ensure storage account is configured with private endpoint"
  name                     = module.naming.storage_account.name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
