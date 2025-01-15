# Azure MSSQL Server
resource "azurerm_sql_server" "this" {
  count = var.database_type == "mssql" ? 1 : 0

  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  connection_policy            = var.connection_policy
  transparent_data_encryption_key_vault_key_id = var.transparent_data_encryption_key_vault_key_id
  minimum_tls_version          = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  primary_user_assigned_identity_id = var.identity != null && length(var.identity) > 0 ? var.identity[0].principal_id : null
  tags                         = var.tags

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator
    content {
      login                     = azuread_administrator.value.login_username
      object_id                 = azuread_administrator.value.object_id
      tenant_id                 = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      principal_id = identity.value.principal_id
      tenant_id    = identity.value.tenant_id
    }
  }
}

# Azure MSSQL Database
resource "azurerm_mssql_database" "this" {
  count = var.database_type == "mssql" ? 1 : 0

  name                = var.db_name
  server_id           = azurerm_sql_server.this[0].id
  collation           = var.collation
  create_mode         = var.create_mode
  sku_name            = var.sku_name
  max_size_gb         = var.max_size_gb
  license_type        = var.license_type
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  min_capacity        = var.min_capacity
  read_scale          = var.read_scale
  zone_redundant      = var.zone_redundant
  tags                = var.tags

  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy != null ? [var.long_term_retention_policy] : []
    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_policy != null ? [var.short_term_retention_policy] : []
    content {
      retention_days             = short_term_retention_policy.value.retention_days
      backup_interval_in_hours   = short_term_retention_policy.value.backup_interval_in_hours
    }
  }

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy != null ? [var.threat_detection_policy] : []
    content {
      state                      = threat_detection_policy.value.state
      disabled_alerts            = threat_detection_policy.value.disabled_alerts
      email_account_admins       = threat_detection_policy.value.email_account_admins
      email_addresses            = threat_detection_policy.value.email_addresses
      retention_days             = threat_detection_policy.value.retention_days
      storage_account_access_key = threat_detection_policy.value.storage_account_access_key
      storage_endpoint           = threat_detection_policy.value.storage_endpoint
    }
  }

  dynamic "import" {
    for_each = var.import != null ? [var.import] : []
    content {
      storage_uri                 = import.value.storage_uri
      storage_key                 = import.value.storage_key
      storage_key_type            = import.value.storage_key_type
      administrator_login         = import.value.administrator_login
      administrator_login_password = import.value.administrator_login_password
      authentication_type         = import.value.authentication_type
      storage_account_id          = import.value.storage_account_id
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [for id in var.identity : { type = "UserAssigned", identity_ids = [id.principal_id] }] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

# Azure MSSQL Firewall Rule
resource "azurerm_sql_firewall_rule" "this" {
  count = var.database_type == "mssql" && length(var.firewall_rules) > 0 ? length(var.firewall_rules) : 0

  name                = format("%s%s", var.firewall_rule_prefix, lookup(var.firewall_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.this[0].name
  start_ip_address    =var.firewall_rules[count.index]["start_ip_address"]
  end_ip_address      =  var.firewall_rules[count.index]["end_ip_address"]
}

# Azure MSSQL Active Directory Administrator
resource "azurerm_sql_active_directory_administrator" "this" {
  count = var.database_type == "mssql" && length(var.active_directory_administrators) > 0 ? length(var.active_directory_administrators) : 0

  login                       = var.sql_aad_administrator.login
  object_id                   = var.sql_aad_administrator.object_id
  resource_group_name         = var.resource_group_name
  server_name                 = azurerm_sql_server.this[0].name
  tenant_id                   = var.sql_aad_administrator.tenant_id
  azuread_authentication_only = var.sql_aad_administrator.azuread_authentication_only
}

resource "azurerm_mssql_database_extended_auditing_policy" "this" {
  count = var.database_type == "mssql" && length(var.extended_auditing_policies) > 0 ? length(var.extended_auditing_policies) : 0

  database_id                           = azurerm_mssql_database.this[0].id
  enabled                               = var.extended_auditing_policies[count.index].enabled
  storage_endpoint                      = var.extended_auditing_policies[count.index].storage_endpoint
  retention_in_days                     = var.extended_auditing_policies[count.index].retention_in_days
  storage_account_access_key            = var.extended_auditing_policies[count.index].storage_account_access_key
  storage_account_access_key_is_secondary = var.extended_auditing_policies[count.index].storage_account_access_key_is_secondary
  log_monitoring_enabled                = var.extended_auditing_policies[count.index].log_monitoring_enabled
}

resource "azurerm_mssql_database_vulnerability_assessment_rule_baseline" "this" {
  count = var.database_type == "mssql" && length(var.vulnerability_assessment_rule_baselines) > 0 ? length(var.vulnerability_assessment_rule_baselines) : 0

  server_vulnerability_assessment_id = azurerm_mssql_server_vulnerability_assessment.this[count.index].id
  database_name                      = azurerm_sql_database.this[0].name
  rule_id                            = var.vulnerability_assessment_rule_baselines[count.index].rule_id
  baseline_name                      = coalesce(var.vulnerability_assessment_rule_baselines[count.index].baseline_name, "default")

  dynamic "baseline_result" {
    for_each = var.vulnerability_assessment_rule_baselines[count.index].baseline_results
    content {
      result = baseline_result.value
    }
  }
  depends_on = [ azurerm_mssql_server_vulnerability_assessment.this ]
}

resource "azurerm_mssql_server_vulnerability_assessment" "this" {
  count = var.database_type == "mssql" && length(var.vulnerability_assessments) > 0 ? length(var.vulnerability_assessments) : 0

  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.this[count.index].id
  storage_container_path          = var.vulnerability_assessments[count.index].storage_container_path
  storage_account_access_key      = var.vulnerability_assessments[count.index].storage_account_access_key
  storage_container_sas_key       = var.vulnerability_assessments[count.index].storage_container_sas_key

  dynamic "recurring_scans" {
    for_each = var.vulnerability_assessments[count.index].recurring_scans != null ? [var.vulnerability_assessments[count.index].recurring_scans] : []
    content {
      enabled                   = recurring_scans.value.enabled
      email_subscription_admins = recurring_scans.value.email_subscription_admins
      emails                    = recurring_scans.value.emails
    }
  }
  depends_on = [ azurerm_mssql_server_security_alert_policy.this ]
}

resource "azurerm_mssql_server_security_alert_policy" "this" {
  count = var.database_type == "mssql" && length(var.security_alert_policies) > 0 ? length(var.security_alert_policies) : 0

  resource_group_name        = var.resource_group_name
  server_name                = azurerm_sql_server.this[0].name
  state                      = var.security_alert_policies[count.index].state
  storage_endpoint           = var.security_alert_policies[count.index].storage_endpoint
  storage_account_access_key = var.security_alert_policies[count.index].storage_account_access_key
  disabled_alerts            = var.security_alert_policies[count.index].disabled_alerts
  email_account_admins       = var.security_alert_policies[count.index].email_account_admins
  email_addresses            = var.security_alert_policies[count.index].email_addresses
  retention_days             = var.security_alert_policies[count.index].retention_days
}
