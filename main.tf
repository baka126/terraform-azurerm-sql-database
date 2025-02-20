#########################################################
# Defines the resources to be created
#########################################################

module "postgresql" {
  source = "./modules/postgresql"

  database_type                     = var.database_type
  server_name                       = var.server_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  sku_name                          = var.postgres_sku_name
  server_version                    = var.postgres_server_version
  administrator_login               = var.administrator_login
  administrator_password            = var.administrator_password
  auto_grow_enabled                 = var.auto_grow_enabled
  backup_retention_days             = var.backup_retention_days
  create_mode                       = var.postgresql_create_mode
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
  authentication                    = var.authentication
  customer_managed_key              = var.customer_managed_key
  high_availability                 = var.high_availability
  identity                          = var.postgres_identity
  maintenance_window                = var.maintenance_window
  active_directory_administrators   = var.active_directory_administrators
  postgresql_configurations         = var.postgresql_configurations
  postgresql_virtual_endpoints      = var.postgresql_virtual_endpoints
  firewall_rules                    = var.postgres_firewall_rules
  db_names                          = var.db_names
  db_charset                        = var.db_charset
  db_collation                      = var.db_collation
  firewall_rule_prefix              = var.firewall_rule_prefix

}

module "mssql" {
  source = "./modules/mssql"

  database_type                                              = var.database_type
  resource_group_name                                        = var.resource_group_name
  administrator_login                                        = var.administrator_login
  administrator_password                                     = var.administrator_password
  server_name                                                = var.server_name
  server_version                                             = var.mssql_server_version
  connection_policy                                          = var.connection_policy
  azuread_administrator                                      = var.azuread_administrator
  transparent_data_encryption_key_vault_key_id               = var.transparent_data_encryption_key_vault_key_id
  transparent_data_encryption_enabled                        = var.transparent_data_encryption_enabled
  transparent_data_encryption_key_automatic_rotation_enabled = var.transparent_data_encryption_key_automatic_rotation_enabled
  minimum_tls_version                                        = var.minimum_tls_version
  outbound_network_restriction_enabled                       = var.outbound_network_restriction_enabled
  public_network_access_enabled                              = var.public_network_access_enabled
  location                                                   = var.location
  db_name                                                    = var.db_name
  collation                                                  = var.collation
  create_mode                                                = var.mssql_create_mode
  elastic_pool_id                                            = var.elastic_pool_id
  enclave_type                                               = var.enclave_type
  geo_backup_enabled                                         = var.geo_backup_enabled
  maintenance_configuration_name                             = var.maintenance_configuration_name
  restore_point_in_time                                      = var.restore_point_in_time
  recover_database_id                                        = var.recover_database_id
  recover_point_id                                           = var.recover_point_id
  restore_dropped_database_id                                = var.restore_dropped_database_id
  restore_long_term_retention_backup_id                      = var.restore_long_term_retention_backup_id
  read_replica_count                                         = var.read_replica_count
  sample_name                                                = var.sample_name
  ledger_enabled                                             = var.ledger_enabled
  creation_source_database_id                                = var.creation_source_database_id
  sku_name                                                   = var.mssql_sku_name
  storage_account_type                                       = var.storage_account_type
  secondary_type                                             = var.secondary_type
  max_size_gb                                                = var.max_size_gb
  license_type                                               = var.license_type
  auto_pause_delay_in_minutes                                = var.auto_pause_delay_in_minutes
  min_capacity                                               = var.min_capacity
  read_scale                                                 = var.read_scale
  zone_redundant                                             = var.zone_redundant
  tags                                                       = var.tags
  import                                                     = var.import
  long_term_retention_policy                                 = var.long_term_retention_policy
  short_term_retention_policy                                = var.short_term_retention_policy
  threat_detection_policy                                    = var.threat_detection_policy
  identity                                                   = var.mssql_identity
  firewall_rules                                             = var.mssql_firewall_rules
  database_extended_auditing_policies                        = var.database_extended_auditing_policies
  vulnerability_assessment_rule_baselines                    = var.vulnerability_assessment_rule_baselines
  vulnerability_assessments                                  = var.vulnerability_assessments
  security_alert_policies                                    = var.security_alert_policies
  elasticpool                                                = var.elasticpool
  failover_groups                                            = var.failover_groups
  jobs                                                       = var.jobs
  job_agents                                                 = var.job_agents
  job_credentials                                            = var.job_credentials
  job_schedules                                              = var.job_schedules
  outbound_firewall_rules                                    = var.outbound_firewall_rules
  extended_auditing_policies                                 = var.extended_auditing_policies
  microsoft_support_auditing_policies                        = var.microsoft_support_auditing_policies
  transparent_data_encryption                                = var.transparent_data_encryption
  dns_aliases                                                = var.dns_aliases

}
