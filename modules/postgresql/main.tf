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
      password_auth_enabled         = var.authentication.value.password_auth_enabled
      active_directory_auth_enabled = var.authentication.value.active_directory_auth_enabled
      tenant_id                     = var.authentication.value.tenant_id
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key
    content {
      key_vault_key_id                     = var.customer_managed_key.value.key_vault_key_id
      primary_user_assigned_identity_id    = var.customer_managed_key.value.primary_user_assigned_identity_id
      geo_backup_key_vault_key_id          = var.customer_managed_key.value.geo_backup_key_vault_key_id
      geo_backup_user_assigned_identity_id = var.customer_managed_key.value.geo_backup_user_assigned_identity_id
    }
  }

  dynamic "high_availability" {
    for_each = var.high_availability
    content {
      mode                      = var.high_availability.value.mode
      standby_availability_zone = var.high_availability.value.standby_availability_zone
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = var.identity.value.type
      identity_ids = var.identity.value.identity_ids
    }

  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window
    content {
      day_of_week  = var.maintenance_window.value.day_of_week
      start_hour   = var.maintenance_window.value.start_hour
      start_minute = var.maintenance_window.value.start_minute
    }

  }
}



resource "azurerm_postgresql_database" "this" {
  count = length(var.db_names) && var.database_type == "postgresql" ? length(var.db_names) : 0

  charset             = var.db_charset
  collation           = var.db_collation
  name                = var.db_names[count.index]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_flexible_server.this.name
}

resource "azurerm_postgresql_firewall_rule" "this" {
  count = length(var.firewall_rules) && var.database_type == "postgresql" ? length(var.firewall_rules) : 0

  end_ip_address      = var.firewall_rules[count.index]["end_ip"]
  name                = format("%s%s", var.firewall_rule_prefix, lookup(var.firewall_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_flexible_server.this.name
  start_ip_address    = var.firewall_rules[count.index]["start_ip"]
}

resource "azurerm_postgresql_virtual_network_rule" "this" {
  count = length(var.vnet_rules) && var.database_type == "postgresql" ? length(var.vnet_rules) : 0

  name                = format("%s%s", var.vnet_rule_name_prefix, lookup(var.vnet_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_flexible_server.this.name
  subnet_id           = var.vnet_rules[count.index]["subnet_id"]
}

resource "azurerm_postgresql_configuration" "this" {
  count = length(keys(var.postgresql_configurations)) && var.database_type == "postgresql" ? length(keys(var.postgresql_configurations)) : 0

  name                = element(keys(var.postgresql_configurations), count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_flexible_server.this.name
  value               = element(values(var.postgresql_configurations), count.index)
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  count = var.database_type == "postgresql" && length(var.active_directory_administrators) > 0 ? length(var.active_directory_administrators) : 0

  server_name         = coalesce(var.active_directory_administrators[count.index].server_name, azurerm_postgresql_flexible_server.this.name)
  resource_group_name = coalesce(var.active_directory_administrators[count.index].resource_group_name, var.resource_group_name)
  object_id           = coalesce(var.active_directory_administrators[count.index].object_id, data.azuread_service_principal.this.object_id)
  tenant_id           = coalesce(var.active_directory_administrators[count.index].tenant_id, data.azurerm_client_config.current.tenant_id)
  principal_name      = coalesce(var.active_directory_administrators[count.index].principal_name, data.azuread_service_principal.this.display_name)
  principal_type      = var.active_directory_administrators[count.index].principal_type
}


