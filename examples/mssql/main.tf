data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = "testRG-${random_id.rg_name.hex}"
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
module "mssql" {
    source = "../../modules/mssql"
  
  database_type = "mssql"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  server_name         = "test-mssql-${random_id.rg_name.hex}"
  server_version = "12.0"
  db_name = "testdb"
  max_size_gb = 20
  administrator_login = "mssqladmin"
  administrator_password = random_password.password.result
  public_network_access_enabled = true

  firewall_rules = [
     {
      name              = "AllowAll"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  ]
}