module "mssql" {
  source = "../../modules/mssql"

  database_type       = "mssql"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  server_name                   = module.naming.mssql_server.name
  server_version                = "12.0"
  db_name                       = module.naming.mssql_database.name
  max_size_gb                   = 20
  administrator_login           = "mssqladmin"
  administrator_password        = random_password.password.result
  public_network_access_enabled = false

  firewall_rules = [
    {
      name             = module.naming.mysql_firewall_rule.name
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  ]

  extended_auditing_policies = [
    {
      storage_endpoint           = azurerm_storage_account.this.primary_blob_endpoint
      storage_account_access_key = azurerm_storage_account.this.primary_access_key
      retention_in_days          = 7
      log_monitoring_enabled     = true
    }
  ]
}
