output "administrator_login" {
  description = "The Administrator login for the PostgreSQL Server"
  value       = var.administrator_login
}

output "administrator_password" {
  description = "The Password associated with the `administrator_login` for the PostgreSQL Server"
  sensitive   = true
  value       = var.administrator_password
}

output "database_ids" {
  description = "The list of all database resource ids"
  value       = [azurerm_postgresql_flexible_server_database.this[*].id]
}

output "firewall_rule_ids" {
  description = "The list of all firewall rule resource ids"
  value       = [azurerm_postgresql_flexible_server_firewall_rule.this[*].id]
}

output "server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.this[0].fqdn
}

output "server_id" {
  description = "The resource id of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.this[0].id
}

output "server_name" {
  description = "The name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.this[0].name
}


#####active directory#####

output "active_directory_administrators_id" {
  description = "The ID of the PostgreSQL Flexible Server Active Directory Administrator."
  value       = azurerm_postgresql_flexible_server_active_directory_administrator.this[*].id
}

#####server config#####

output "postgresql_configurations_id" {
  description = "The ID of the PostgreSQL Flexible Server Configuration."
  value       = [azurerm_postgresql_flexible_server_configuration.this[*].id]
}

output "virtual_endpoints_id" {
  description = "The ID of the PostgreSQL Flexible Server Virtual Endpoint."
  value       = [azurerm_postgresql_flexible_server_virtual_endpoint.this[*].id]

}
