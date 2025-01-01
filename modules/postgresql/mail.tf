resource "azurerm_postgresql_server" "this" {
  count                             = var.database_type == "postgresql" ? 1 : 0
  location                          = var.location
  name                              = var.server_name
  resource_group_name               = var.resource_group_name
  sku_name                          = var.sku_name
  ssl_enforcement_enabled           = var.ssl_enforcement_enabled
  version                           = var.server_version
  administrator_login               = var.administrator_login
  administrator_login_password      = var.administrator_password
  auto_grow_enabled                 = var.auto_grow_enabled
  backup_retention_days             = var.backup_retention_days
  create_mode                       = var.create_mode
  creation_source_server_id         = var.creation_source_server_id
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  ssl_minimal_tls_version_enforced  = var.ssl_minimal_tls_version_enforced
  storage_mb                        = var.storage_mb
  tags                              = var.tags

  dynamic "threat_detection_policy" {
    for_each = nonsensitive(var.threat_detection_policy) != null ? ["threat_detection_policy"] : []

    content {
      disabled_alerts            = var.threat_detection_policy.disabled_alerts
      email_account_admins       = var.threat_detection_policy.email_account_admins
      email_addresses            = var.threat_detection_policy.email_addresses
      enabled                    = var.threat_detection_policy.enabled
      retention_days             = var.threat_detection_policy.retention_days
      storage_account_access_key = var.threat_detection_policy.storage_account_access_key
      storage_endpoint           = var.threat_detection_policy.storage_endpoint
    }
  }
}

resource "azurerm_postgresql_database" "dbs" {
  count = length(var.db_names) && var.database_type == "postgresql" ? length(var.db_names) : 0

  charset             = var.db_charset
  collation           = var.db_collation
  name                = var.db_names[count.index]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
}

resource "azurerm_postgresql_firewall_rule" "firewall_rules" {
  count = length(var.firewall_rules) && var.database_type == "postgresql" ? length(var.firewall_rules) : 0

  end_ip_address      = var.firewall_rules[count.index]["end_ip"]
  name                = format("%s%s", var.firewall_rule_prefix, lookup(var.firewall_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  start_ip_address    = var.firewall_rules[count.index]["start_ip"]
}

resource "azurerm_postgresql_virtual_network_rule" "vnet_rules" {
  count = length(var.vnet_rules) && var.database_type == "postgresql" ? length(var.vnet_rules) : 0

  name                = format("%s%s", var.vnet_rule_name_prefix, lookup(var.vnet_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  subnet_id           = var.vnet_rules[count.index]["subnet_id"]
}

resource "azurerm_postgresql_configuration" "db_configs" {
  count = length(keys(var.postgresql_configurations)) && var.database_type == "postgresql" ? length(keys(var.postgresql_configurations)) : 0

  name                = element(keys(var.postgresql_configurations), count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  value               = element(values(var.postgresql_configurations), count.index)
}