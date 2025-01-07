resource "azurerm_postgresql_flexible_server" "this" {
  count = var.database_type == "postgresql" ? 1 : 0

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
  delegated_subnet_id               = var.delegated_subnet_id
  private_dns_zone_id               = var.private_dns_zone_id
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  point_in_time_restore_time_in_utc = var.point_in_time_restore_time_in_utc
  replication_role                  = var.replication_role
  source_server_id                  = var.source_server_id
  storage_mb                        = var.storage_mb
  storage_tier                      = var.storage_tier
  zone                              = var.zone
  tags                              = var.tags

dynamic "authentication" {
  for_each = var.authentication
  content {
    password_auth_enabled         = authentication.value.password_auth_enabled
    active_directory_auth_enabled = authentication.value.active_directory_auth_enabled
    tenant_id                     = authentication.value.tenant_id
  }
}

dynamic "customer_managed_key" {
  for_each = var.customer_managed_key
  content {
    key_vault_key_id                     = customer_managed_key.value.key_vault_key_id
    primary_user_assigned_identity_id    = customer_managed_key.value.primary_user_assigned_identity_id
    geo_backup_key_vault_key_id          = customer_managed_key.value.geo_backup_key_vault_key_id
    geo_backup_user_assigned_identity_id = customer_managed_key.value.geo_backup_user_assigned_identity_id
  }
}

dynamic "high_availability" {
  for_each = var.high_availability
  content {
    mode                      = high_availability.value.mode
    standby_availability_zone = high_availability.value.standby_availability_zone
  }
}

dynamic "identity" {
  for_each = var.identity
  content {
    type         = identity.value.type
    identity_ids = identity.value.identity_ids
  }
}

dynamic "maintenance_window" {
  for_each = var.maintenance_window
  content {
    day_of_week  = maintenance_window.value.day_of_week
    start_hour   = maintenance_window.value.start_hour
    start_minute = maintenance_window.value.start_minute
  }
}

}

resource "azurerm_postgresql_flexible_server_database" "this" {
  count = var.database_type == "postgresql" && length(var.db_names) > 0 ? length(var.db_names) : 0

  name      = var.db_names[count.index]
  server_id = azurerm_postgresql_flexible_server.this[0].id
  charset   = var.db_charset
  collation = var.db_collation
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  count = var.database_type == "postgresql" && length(var.firewall_rules) > 0 ? length(var.firewall_rules) : 0

  name             = format("%s%s", var.firewall_rule_prefix, lookup(var.firewall_rules[count.index], "name", count.index))
  server_id        = azurerm_postgresql_flexible_server.this[0].id
  start_ip_address = var.firewall_rules[count.index]["start_ip_address"]
  end_ip_address   = var.firewall_rules[count.index]["end_ip_address"]

}

resource "azurerm_postgresql_flexible_server_virtual_endpoint" "this" {
  count = var.database_type == "postgresql" && length(var.postgresql_virtual_endpoints) > 0 ? length(var.postgresql_virtual_endpoints) : 0

  name              = var.postgresql_virtual_endpoints[count.index].name
  source_server_id  = var.postgresql_virtual_endpoints[count.index].source_server_id
  replica_server_id = var.postgresql_virtual_endpoints[count.index].replica_server_id
  type              = var.postgresql_virtual_endpoints[count.index].type

  depends_on = [
    azurerm_postgresql_flexible_server.this
  ]
}


resource "azurerm_postgresql_flexible_server_configuration" "this" {
  count = var.database_type == "postgresql" && length(var.postgresql_configurations) > 0 ? length(var.postgresql_configurations) : 0

  name      = var.postgresql_configurations[count.index].name
  server_id = azurerm_postgresql_flexible_server.this[0].id
  value     = var.postgresql_configurations[count.index].value
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  count = var.database_type == "postgresql" && length(var.active_directory_administrators) > 0 ? length(var.active_directory_administrators) : 0

  server_name         = coalesce(var.active_directory_administrators[count.index].server_name, azurerm_postgresql_flexible_server.this[0].name)
  resource_group_name = coalesce(var.active_directory_administrators[count.index].resource_group_name, var.resource_group_name)
  object_id           = var.active_directory_administrators[count.index].object_id 
  tenant_id           = coalesce(var.active_directory_administrators[count.index].tenant_id, data.azurerm_client_config.current.tenant_id)
  principal_name      = var.active_directory_administrators[count.index].principal_name 
  principal_type      = var.active_directory_administrators[count.index].principal_type
}
