output "connection_string" {
  description = "Connection string for the Azure SQL Database created."
  sensitive   = true
  value       = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.server.administrator_login};Password=${azurerm_sql_server.server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

output "database_name" {
  description = "Database name of the Azure SQL Database created."
  value       = azurerm_mssql_database.db.name
}

output "mssql_server_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) of the Azure SQL Database created."
  value       = azurerm_mssql_server.server.fully_qualified_domain_name
}

output "mssql_server_location" {
  description = "Location of the Azure SQL Database created."
  value       = azurerm_mssql_server.server.location
}

output "mssql_server_name" {
  description = "Server name of the Azure SQL Database created."
  value       = azurerm_mssql_server.server.name
}

output "mssql_server_version" {
  description = "Version the Azure SQL Database created."
  value       = azurerm_mssql_server.server.version
}

output "mssql_server_security_alert_policy_ids" {
  value       = azurerm_mssql_server_security_alert_policy.this[*].id
  description = "The IDs of the MS SQL Server Security Alert Policies."
}

output "mssql_server_vulnerability_assessment_ids" {
  value       = azurerm_mssql_server_vulnerability_assessment.this[*].id
  description = "The IDs of the MS SQL Server Vulnerability Assessments."
}

output "azurerm_mssql_elasticpool_id" {
  value       = azurerm_mssql_elasticpool.this.id
  description = "The ID of the MS SQL Server Elastic Pool." 
}


output "failover_group_ids" {
  value       = azurerm_mssql_failover_group.this[*].id
  description = "The IDs of the created MSSQL Failover Groups."
}


output "firewall_rule_ids" {
  value       = azurerm_mssql_firewall_rule.this[*].id
  description = "The IDs of the created MSSQL Firewall Rules."
}

output "job_ids" {
  value       = azurerm_mssql_job.this[*].id
  description = "The IDs of the created MSSQL Elastic Jobs."
}

output "job_agent_ids" {
  value       = azurerm_mssql_job_agent.this[*].id
  description = "The IDs of the created MSSQL Elastic Job Agents."
}

output "job_credential_ids" {
  value       = azurerm_mssql_job_credential.this[*].id
  description = "The IDs of the created MSSQL Elastic Job Credentials."
}

output "mssql_job_schedule_ids" {
  description = "The IDs of the created MSSQL Job Schedules."
  value       = azurerm_mssql_job_schedule.this[*].id
}

output "mssql_outbound_firewall_rule_ids" {
  description = "The IDs of the created MSSQL Outbound Firewall Rules."
  value       = azurerm_mssql_outbound_firewall_rule.this[*].id
}

output "mssql_server_dns_alias_ids" {
  description = "The IDs of the created MSSQL Server DNS Aliases."
  value       = azurerm_mssql_server_dns_alias.this[*].id
}

output "mssql_server_dns_alias_dns_records" {
  description = "The fully qualified DNS records for the created MSSQL Server DNS Aliases."
  value       = azurerm_mssql_server_dns_alias.this[*].dns_record
}
