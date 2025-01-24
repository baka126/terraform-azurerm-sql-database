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
