####azure mssql server####
variable "resource_group_name" {
  type        = string
  description = "Default resource group name that the database will be created in."
}

variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  default = null
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login for the PostgreSQL Server."
  sensitive   = true
  default = null
}

variable "server_name" {
  type        = string
  description = "Specifies the name of the mssql Server. Changing this forces a new resource to be created."
}

variable "server_version" {
  type        = string
  default     = "12.0"
  description = "The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
}

variable "database_type" {
  type        = string
  description = "Type of database to be created"

  validation {
    condition     = contains(["mssql", "postgresql"], var.database_type)
    error_message = "Valid values for database_type are 'mssql' or 'postgresql'."
  }
}

variable "connection_policy" {
  type        = string
  default     = "Default"
  description = " The connection policy the server will use. Possible values are Default, Proxy, and Redirect"
  
}

variable "azuread_administrator" {
  type    = list(object({
    login_username = string
    object_id      = string
    tenant_id      = string
    azuread_authentication_only = optional(bool, false) #  When true, the administrator_login and administrator_login_password properties can be omitted.
  }))
  default = []
  description = "Authentication configuration, known in the API as Server Active Directory Administrator details"
}

variable "identity" {
  type    = list(object({
    principal_id         = string
    tenant_id = string
  }))
  default = []
  description = "Identity configuration, For type The only possible value is UserAssigned"
}

variable "transparent_data_encryption_key_vault_key_id" {
  type        = string
  default     = null
  description = "The ID of the Azure Key Vault key used to encrypt the data at rest. (e.g. 'https://<YourVaultName>.vault.azure.net/keys/<YourKeyName>/<YourKeyVersion>) to be used as the customer-managed key to encrypt the data at rest for the server."  
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "The minimum supported TLS version. Possible values are 1.0, 1.1, and 1.2"
  
}

variable "outbound_network_restriction_enabled" {
  type = bool
  default = false
  description = "Whether outbound network traffic is restricted for this server. Defaults to false"
}

variable "primary_user_assigned_identity_id" {
  type        = string
  default     = null
  description = "The id of the primary user assigned identity"
  
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether or not public network access is allowed for this server. Defaults to true."
  
}
####azure mssql database####
variable "location" {
  type        = string
  description = "The location/region where the database and server are created. Changing this forces a new resource to be created."
}

variable "db_name" {
  description = "The name of the MS SQL Database."
  type        = string
}

variable "collation" {
  description = "Specifies the collation of the database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "create_mode" {
  description = "The create mode of the database."
  type        = string
  default     = "Default"
}

variable "sku_name" {
  description = "Specifies the name of the SKU used by the database."
  type        = string
  default     = "S0"
}

variable "max_size_gb" {
  description = "The max size of the database in gigabytes."
  type        = number
  default     = 2
}

variable "license_type" {
  description = "Specifies the license type applied to this database."
  type        = string
  default     = "LicenseIncluded"
}

variable "auto_pause_delay_in_minutes" {
  description = "Time in minutes after which database is automatically paused."
  type        = number
  default     = -1
}

variable "min_capacity" {
  description = "Minimal capacity that database will always have allocated, if not paused."
  type        = number
  default     = null
}

variable "read_scale" {
  description = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica."
  type        = bool
  default     = false
}

variable "zone_redundant" {
  description = "Whether or not this database is zone redundant."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "import" {
  description = "Import block for database creation."
  type = object({
    storage_uri                  = string
    storage_key                  = string
    storage_key_type             = string
    administrator_login          = string
    administrator_login_password = string
    authentication_type          = string
  })
  default = null
}

variable "long_term_retention_policy" {
  description = "Long-term retention policy block."
  type = object({
    weekly_retention  = string
    monthly_retention = string
    yearly_retention  = string
    week_of_year      = number
  })
  default = null
}

variable "short_term_retention_policy" {
  description = "Short-term retention policy block."
  type = object({
    retention_days = number
  })
  default = null
}

variable "threat_detection_policy" {
  description = "Threat detection policy block."
  type = object({
    state                      = string
    disabled_alerts            = list(string)
    email_account_admins       = string
    email_addresses            = list(string)
    retention_days             = number
    storage_account_access_key = string
    storage_endpoint           = string
  })
  default = null
}

variable "identity" {
  description = "Identity block for the database."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}

############azure firewall rule############
variable "firewall_rule_prefix" {
  type        = string
  default     = "firewall-"
  description = "Specifies prefix for firewall rule names."
}

variable "firewall_rules" {
  type        = list(map(string))
  default     = []
  description = "The list of maps, describing firewall rules. Valid map items: name, start_ip, end_ip."
}


###########
variable "end_ip_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Defines the end IP address used in your database firewall rule."
}

variable "service_objective_name" {
  type        = string
  default     = "Basic"
  description = "The performance level for the database. For the list of acceptable values, see https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers. Default is Basic."
}

variable "active_directory_administrators" {
  type = object({
    login                       = string
    object_id                   = string
    tenant_id                   = string
    azuread_authentication_only = optional(bool)
  })
  default     = null
  description = <<-EOF
  object({
    login = (Required) The login name of the principal to set as the server administrator
    object_id = (Required) The ID of the principal to set as the server administrator
    tenant_id = (Required) The Azure Tenant ID
    azuread_authentication_only = (Optional) Specifies whether only AD Users and administrators can be used to login (`true`) or also local database users (`false`).
  })
EOF
}

variable "start_ip_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Defines the start IP address used in your database firewall rule."
}

variable "tags" {
  type = map(string)
  default = {
    tag1 = ""
    tag2 = ""
  }
  description = "The tags to associate with your network and subnets."
}

#####azurerm_mssql_database_extended_auditing_policy#######
variable "extended_auditing_policies" {
  description = "List of extended auditing policies for MSSQL databases."
  type = list(object({
    database_id                           = string
    enabled                               = optional(bool, true)
    storage_endpoint                      = optional(string)
    retention_in_days                     = optional(number, 0)
    storage_account_access_key            = optional(string)
    storage_account_access_key_is_secondary = optional(bool, false)
    log_monitoring_enabled                = optional(bool, true)
  }))
  default = []
}
######vulnerability_assessment_rule_baselines######
variable "vulnerability_assessment_rule_baselines" {
  type = list(object({
    server_vulnerability_assessment_id = string
    database_name                      = string
    rule_id                            = string
    baseline_name                      = optional(string, "default")
    baseline_results                   = list(list(string))
  }))
  default     = []
  description = "List of vulnerability assessment rule baselines for MS SQL databases."
}

variable "vulnerability_assessments" {
  type = list(object({
    server_security_alert_policy_id = string
    storage_container_path          = string
    storage_account_access_key      = optional(string)
    storage_container_sas_key       = optional(string)
    recurring_scans = optional(object({
      enabled                   = bool
      email_subscription_admins = bool
      emails                    = list(string)
    }))
  }))
  default     = []
  description = "List of vulnerability assessments to configure for MS SQL Server."
}

variable "security_alert_policies" {
  type = list(object({
    resource_group_name        = string
    server_name                = string
    state                      = string //Possible values are Disabled, Enabled and New.
    storage_endpoint           = optional(string)
    storage_account_access_key = optional(string)
    disabled_alerts            = optional(list(string)) // Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action.
    email_account_admins       = optional(bool)
    email_addresses            = optional(list(string))
    retention_days             = optional(number)
  }))
  default     = []
  description = "List of security alert policies to configure for MS SQL Server."
}