################################################################################
# Postgres outputs
################################################################################
output "administrator_login" {
  description = "The Administrator login for the PostgreSQL Server"
  value       = module.postgresql.administrator_login
}

output "administrator_password" {
  description = "The Password associated with the `administrator_login` for the PostgreSQL Server"
  sensitive   = true
  value       = module.postgresql.administrator_password
}

output "database_ids" {
  description = "The list of all database resource ids"
  value       = module.postgresql.database_ids
}

output "firewall_rule_ids" {
  description = "The list of all firewall rule resource ids"
  value       = module.postgresql.firewall_rule_ids
}

output "server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the PostgreSQL server"
  value       = module.postgresql.server_fqdn
}

output "server_id" {
  description = "The resource id of the PostgreSQL server"
  value       = module.postgresql.server_id
}

output "server_name" {
  description = "The name of the PostgreSQL server"
  value       = module.postgresql.server_name
}


#####active directory#####

output "active_directory_administrators_id" {
  description = "The ID of the PostgreSQL Flexible Server Active Directory Administrator."
  value       = module.postgresql.active_directory_administrators_id
}

#####server config#####

output "postgresql_configurations_id" {
  description = "The ID of the PostgreSQL Flexible Server Configuration."
  value       = module.postgresql.postgresql_configurations_id
}

output "virtual_endpoints_id" {
  description = "The ID of the PostgreSQL Flexible Server Virtual Endpoint."
  value       = module.postgresql.virtual_endpoints_id

}

################################################################################
# mssql outputs
################################################################################
output "mssql_connection_string" {
  description = "Connection string for the Azure SQL Database created."
  sensitive   = true
  value       = module.mssql.connection_string
}

output "mssql_database_name" {
  description = "Database name of the Azure SQL Database created."
  value       = module.mssql.database_name
}

output "mssql_server_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) of the Azure SQL Database created."
  value       = module.mssql.mssql_server_fqdn
}

output "mssql_server_location" {
  description = "Location of the Azure SQL Database created."
  value       = module.mssql.mssql_server_location
}

output "mssql_server_name" {
  description = "Server name of the Azure SQL Database created."
  value       = module.mssql.mssql_server_name
}

output "mssql_server_version" {
  description = "Version the Azure SQL Database created."
  value       = module.mssql.mssql_server_version
}

output "mssql_server_security_alert_policy_ids" {
  value       = module.mssql.mssql_server_security_alert_policy_ids
  description = "The IDs of the MS SQL Server Security Alert Policies."
}

output "mssql_server_vulnerability_assessment_ids" {
  value       = module.mssql.mssql_server_vulnerability_assessment_ids
  description = "The IDs of the MS SQL Server Vulnerability Assessments."
}

output "mssql_elasticpool_id" {
  value       = module.mssql.azurerm_mssql_elasticpool_id
  description = "The ID of the MS SQL Server Elastic Pool."
}


output "mssql_failover_group_ids" {
  value       = module.mssql.failover_group_ids
  description = "The IDs of the created MSSQL Failover Groups."
}


output "mssql_firewall_rule_ids" {
  value       = module.mssql.firewall_rule_ids
  description = "The IDs of the created MSSQL Firewall Rules."
}

output "mssql_job_ids" {
  value       = module.mssql.job_ids
  description = "The IDs of the created MSSQL Elastic Jobs."
}

output "mssql_job_agent_ids" {
  value       = module.mssql.job_agent_ids
  description = "The IDs of the created MSSQL Elastic Job Agents."
}

output "mssql_job_credential_ids" {
  value       = module.mssql.job_credential_ids
  description = "The IDs of the created MSSQL Elastic Job Credentials."
}

output "mssql_job_schedule_ids" {
  description = "The IDs of the created MSSQL Job Schedules."
  value       = module.mssql.mssql_job_schedule_ids
}

output "mssql_outbound_firewall_rule_ids" {
  description = "The IDs of the created MSSQL Outbound Firewall Rules."
  value       = module.mssql.mssql_outbound_firewall_rule_ids
}

output "mssql_server_dns_alias_ids" {
  description = "The IDs of the created MSSQL Server DNS Aliases."
  value       = module.mssql.mssql_server_dns_alias_ids
}

output "mssql_server_dns_alias_dns_records" {
  description = "The fully qualified DNS records for the created MSSQL Server DNS Aliases."
  value       = module.mssql.mssql_server_dns_alias_dns_records
}

output "mssql_server_extended_auditing_policy_ids" {
  description = "The IDs of the created MSSQL Server Extended Auditing Policies."
  value       = module.mssql.mssql_server_extended_auditing_policy_ids
}

output "mssql_server_microsoft_support_auditing_policy_ids" {
  description = "The IDs of the created MSSQL Server Microsoft Support Auditing Policies."
  value       = module.mssql.mssql_server_microsoft_support_auditing_policy_ids
}

output "mssql_server_tde_ids" {
  description = "The IDs of the created MSSQL Server Transparent Data Encryption resources."
  value       = module.mssql.mssql_server_tde_ids
}
