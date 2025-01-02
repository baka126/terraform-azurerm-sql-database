resource "azurerm_postgresql_flexible_server" "this" {
  count                             = var.database_type == "postgresql" ? 1 : 0
  
  name                              = var.server_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  sku_name                          = var.sku_name
  version                           = var.server_version
  administrator_login               = var.administrator_login
  administrator_password            = var.administrator_password
  auto_grow_enabled                 = var.auto_grow_enabled
  backup_retention_days             = var.backup_retention_days
  create_mode                       = var.create_mode
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  storage_mb                        = var.storage_mb
  storage_tier                      = var.storage_tier 
  tags                              = var.tags

  dynamic "authentication" {
    for_each = var.authentication
    content {
      password_auth_enabled = var.authentication.value.password_auth_enabled
      active_directory_auth_enabled =  var.authentication.value.active_directory_auth_enabled
      tenant_id =  var.authentication.value.tenant_id
    }
  }


}

resource "azurerm_postgresql_database" "this" {
  count = length(var.db_names) && var.database_type == "postgresql" ? length(var.db_names) : 0

  charset             = var.db_charset
  collation           = var.db_collation
  name                = var.db_names[count.index]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
}

resource "azurerm_postgresql_firewall_rule" "this" {
  count = length(var.firewall_rules) && var.database_type == "postgresql" ? length(var.firewall_rules) : 0

  end_ip_address      = var.firewall_rules[count.index]["end_ip"]
  name                = format("%s%s", var.firewall_rule_prefix, lookup(var.firewall_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = var.firewall_rules[count.index]["start_ip"]
}

resource "azurerm_postgresql_virtual_network_rule" "this" {
  count = length(var.vnet_rules) && var.database_type == "postgresql" ? length(var.vnet_rules) : 0

  name                = format("%s%s", var.vnet_rule_name_prefix, lookup(var.vnet_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  subnet_id           = var.vnet_rules[count.index]["subnet_id"]
}

resource "azurerm_postgresql_configuration" "this" {
  count = length(keys(var.postgresql_configurations)) && var.database_type == "postgresql" ? length(keys(var.postgresql_configurations)) : 0

  name                = element(keys(var.postgresql_configurations), count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = element(values(var.postgresql_configurations), count.index)
}