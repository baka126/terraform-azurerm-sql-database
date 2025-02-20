#trivy:ignore:AVD-AZU-0022 "Database server has public network access enabled."
module "mssql" {
  source = "../../modules/mssql"
  # checkov:skip=CKV_AZURE_2: "Ensure that Storage Account is encrypted with Customer Managed Keys"
  # checkov:skip=CKV_AZURE_33: "Ensure Storage logging is enabled for Queue service for read, write and delete requests"
  # checkov:skip=CKV_AZURE_206: "Ensure that Storage Accounts use replication"
  # checkov:skip=CKV2_AZURE_38: "Ensure soft-delete is enabled on Azure storage account"
  # checkov:skip=CKV_AZURE_190: "Ensure that Storage blobs restrict public access"

  # checkov:skip=CKV2_AZURE_45  # Skipping "Ensure Microsoft SQL server is configured with private endpoint"
  # checkov:skip=CKV_AZURE_23   # Skipping "Ensure that 'Auditing' is set to 'On' for SQL servers"
  # checkov:skip=CKV_AZURE_24   # Skipping "Ensure that 'Auditing' Retention is 'greater than 90 days' for SQL servers"
  # checkov:skip=CKV2_AZURE_4   # Skipping "Ensure Azure SQL server ADS VA Send scan reports to is configured"
  # checkov:skip=CKV2_AZURE_3   # Skipping "Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server"
  # checkov:skip=CKV2_AZURE_5   # Skipping "Ensure that VA setting 'Also send email notifications to admins and subscription owners' is set for a SQL server"
  # checkov:skip=CKV_AZURE_113: "Ensure that SQL server disables public network access"
  # checkov:skip=CKV_AZURE_229:: "Ensure the Azure SQL Database Namespace is zone redundant"



  database_type       = "mssql"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  server_name                   = module.naming.mssql_server.name
  server_version                = "12.0"
  db_name                       = module.naming.mssql_database.name
  max_size_gb                   = 20
  administrator_login           = "mssqladmin"
  administrator_password        = random_password.password.result
  public_network_access_enabled = true
  zone_redundant                = false
  ledger_enabled                = true

  firewall_rules = [
    {
      name             = module.naming.mysql_firewall_rule.name
      start_ip_address = "192.168.1.1"
      end_ip_address   = "192.168.1.1"
    }
  ]

  extended_auditing_policies = [
    {
      storage_endpoint                        = azurerm_storage_account.this.primary_blob_endpoint
      storage_account_access_key              = azurerm_storage_account.this.primary_access_key
      storage_account_access_key_is_secondary = true
      retention_in_days                       = 100
      log_monitoring_enabled                  = true
    }
  ]

  security_alert_policies = [
    {
      state                = "Enabled"
      email_account_admins = true
      disabled_alerts      = []
      email_addresses      = ["admin@example.com"]
    }
  ]
  # Vulnerability Assessment Configuration
  vulnerability_assessments = [
    {
      storage_container_path     = "${azurerm_storage_account.this.primary_blob_endpoint}${azurerm_storage_container.this.name}/"
      storage_account_access_key = azurerm_storage_account.this.primary_access_key
      recurring_scans = {
        enabled                   = true
        email_subscription_admins = true
        emails = [
          "email@example1.com",
          "email@example2.com"
        ]
      }

    }
  ]
}
