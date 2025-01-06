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

resource "azurerm_resource_group" "test" {
  location = var.location
  name     = "testRG-${random_id.rg_name.hex}"
}

module "postgresql" {
  source = "../../modules/postgresql"

  database_type       = "postgresql"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  sku_name            = "GP_Standard_D2s_v3"

  server_name                   = "test-pg-primary-${random_id.rg_name.hex}"
  administrator_login           = "login"
  administrator_password        = random_password.password.result
  public_network_access_enabled = true
  db_names                      = ["db1"]

  maintenance_window = [
    {
      day_of_week  = 1
      start_hour   = 0
      start_minute = 0
    }
  ]

  firewall_rules = [
    {
      name             = "AllowAll"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
    {
      name             = "AllowAll2"
      start_ip_address = "192.168.1.0"
      end_ip_address   = "192.168.1.255"
    }
  ]

  postgresql_configurations = [
    {
      name  = "log_connections"
      value = "on"
    }
  ]
}

resource "time_sleep" "sleep" {
  create_duration = "1m"

  depends_on = [module.postgresql]
}

module "postgresql_replica" {
  # checkov:skip=CKV_AZURE_136: "Ensure that PostgreSQL Flexible server enables geo-redundant backups"
  source = "../../modules/postgresql"

  database_type       = "postgresql"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  sku_name            = "GP_Standard_D2s_v3"

  server_name                  = "test-pg-replica-${random_id.rg_name.hex}"
  administrator_login          = "login"
  administrator_password       = random_password.password.result
  geo_redundant_backup_enabled = false

  create_mode      = "Replica"
  source_server_id = module.postgresql.server_id
  depends_on       = [time_sleep.sleep]
}
