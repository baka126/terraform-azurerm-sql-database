output "database_name" {
  description = "Database name of the Azure SQL Database created."
  value       = module.mssql.database_name
}

output "mssql_server_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) of the Azure SQL Database created."
  value       = module.mssql.mssql_server_fqdn
}
output "mssql_server_name" {
  description = "Server name of the Azure SQL Database created."
  value       = module.mssql.mssql_server_name
}

output "mssql_server_security_alert_policy_ids" {
  value       = module.mssql.mssql_server_security_alert_policy_ids
  description = "The IDs of the MS SQL Server Security Alert Policies."
}

output "mssql_server_vulnerability_assessment_ids" {
  value       = module.mssql.mssql_server_vulnerability_assessment_ids
  description = "The IDs of the MS SQL Server Vulnerability Assessments."
}

output "firewall_rule_ids" {
  value       = module.mssql.firewall_rule_ids
  description = "The IDs of the created MSSQL Firewall Rules."
}

output "mssql_server_extended_auditing_policy_ids" {
  description = "The IDs of the created MSSQL Server Extended Auditing Policies."
  value       = module.mssql.mssql_server_extended_auditing_policy_ids
}
