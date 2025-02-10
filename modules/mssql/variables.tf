####azure mssql server####
variable "resource_group_name" {
  type        = string
  description = "Default resource group name that the database will be created in."
}

variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the mssql Server. Changing this forces a new resource to be created."
  default     = null
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login for the PostgreSQL Server."
  sensitive   = true
  default     = null
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
  type = list(object({
    login_username              = string
    object_id                   = string
    tenant_id                   = string
    azuread_authentication_only = optional(bool, false) #  When true, the administrator_login and administrator_login_password properties can be omitted.
  }))
  default     = []
  description = "Authentication configuration, known in the API as Server Active Directory Administrator details"
}


variable "transparent_data_encryption_key_vault_key_id" {
  type        = string
  default     = null
  description = "The ID of the Azure Key Vault key used to encrypt the data at rest. (e.g. 'https://<YourVaultName>.vault.azure.net/keys/<YourKeyName>/<YourKeyVersion>) to be used as the customer-managed key to encrypt the data at rest for the server."
}

variable "transparent_data_encryption_enabled" {
  type        = bool
  default     = true
  description = "Whether or not transparent data encryption is enabled. Defaults to true."

}

variable "transparent_data_encryption_key_automatic_rotation_enabled" {
  type        = bool
  default     = false
  description = "Whether or not automatic key rotation is enabled. Defaults to false."

}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "The minimum supported TLS version. Possible values are 1.0, 1.1, and 1.2"

}

variable "outbound_network_restriction_enabled" {
  type        = bool
  default     = false
  description = "Whether outbound network traffic is restricted for this server. Defaults to false"
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
  description = " The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary."
  type        = string
  default     = "Default"
}

variable "elastic_pool_id" {
  description = " Specifies the ID of the elastic pool containing this database."
  type        = string
  default     = null
}

variable "enclave_type" {
  description = "Possible values are Default or VBS"
  type        = string
  default     = "Default"
}

variable "geo_backup_enabled" {
  description = "Specifies if geo backup is enabled for this database."
  type        = bool
  default     = true
}

variable "maintenance_configuration_name" {
  description = "The name of the Public Maintenance Configuration window to apply to the database. "
  type        = string
  default     = "SQL_Default"
  validation {
    condition     = var.elastic_pool_id == null || (var.elastic_pool_id != null && var.maintenance_configuration_name != "")
    error_message = "maintenance_configuration_name is only applicable if elastic_pool_id is not set."
  }
}

variable "restore_point_in_time" {
  description = "Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database."
  type        = string
  default     = null
  validation {
    condition     = var.create_mode != "PointInTimeRestore" || (var.create_mode == "PointInTimeRestore" && var.restore_point_in_time != null)
    error_message = "restore_point_in_time is only applicable if create_mode is PointInTimeRestore and must not be null when create_mode is PointInTimeRestore."
  }
}

variable "recover_database_id" {
  description = "The ID of the database to be recovered. This property is only applicable when the create_mode is Recovery."
  type        = string
  default     = null
  validation {
    condition     = var.create_mode != "Recovery" || (var.create_mode == "Recovery" && var.recover_database_id != null)
    error_message = "recover_database_id is only applicable if create_mode is Recovery and must not be null when create_mode is Recovery."
  }
}

variable "recover_point_id" {
  description = "The ID of the Recovery Services Recovery Point Id to be restored. This property is only applicable when the create_mode is Recovery."
  type        = string
  default     = null
  validation {
    condition     = var.create_mode != "Recovery" || (var.create_mode == "Recovery" && var.recover_point_id != null)
    error_message = "restore_point_id is only applicable if create_mode is Recovery."
  }
}

variable "restore_dropped_database_id" {
  description = "The ID of the database to be restored. This property is only applicable when the create_mode is Restore."
  type        = string
  default     = null
  validation {
    condition     = var.create_mode != "Restore" || (var.create_mode == "Restore" && var.restore_dropped_database_id != null)
    error_message = "restore_dropped_database_id is only applicable if create_mode is Restore and must not be null when create_mode is Restore."
  }
}

variable "restore_long_term_retention_backup_id" {
  description = "The ID of the long term retention backup to be restored. This property is only applicable when the create_mode is RestoreLongTermRetentionBackup."
  type        = string
  default     = null
  validation {
    condition     = var.create_mode != "RestoreLongTermRetentionBackup" || (var.create_mode == "RestoreLongTermRetentionBackup" && var.restore_long_term_retention_backup_id != null)
    error_message = "restore_long_term_retention_backup_id is only applicable if create_mode is RestoreLongTermRetentionBackup and must not be null when create_mode is RestoreLongTermRetentionBackup."
  }
}

variable "read_replica_count" {
  description = "The number of readonly secondary replicas associated with the database to which readonly application intent connections may be routed. This property is only settable for Hyperscale edition databases."
  type        = number
  default     = null
}

variable "sample_name" {
  description = "Specifies the name of the sample schema to apply when creating this database. Possible value is AdventureWorksLT."
  type        = string
  default     = null
  validation {
    condition     = var.sample_name == null || var.sample_name == "AdventureWorksLT"
    error_message = "sample_name is only applicable if sample_name is AdventureWorksLT."
  }
}

variable "ledger_enabled" {
  description = "A boolean that specifies if this is a ledger database. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "creation_source_database_id" {
  description = "The ID of the source database from which to create the new database. This should only be used for databases with create_mode values that use another database as reference. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
variable "sku_name" {
  description = "Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100."
  type        = string
  default     = null
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone. Defaults to Geo  ."
  type        = string
  default     = "Geo"
}

variable "secondary_type" {
  description = "How do you want your replica to be made? Valid values include Geo and Named. Defaults to Geo. "
  type        = string
  default     = "Geo"
}

variable "max_size_gb" {
  description = "The max size of the database in gigabytes."
  type        = number
  default     = 20
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
    identity_ids = optional(list(string), [])
  })
  default = null
}

############azure firewall rule############
variable "firewall_rules" {
  type = list(object({
    name             = string
    server_id        = optional(string)
    start_ip_address = string
    end_ip_address   = string
  }))
  default     = []
  description = "Values for configuring MSSQL Firewall Rules"
}

#####azurerm_mssql_database_extended_auditing_policy#######
variable "database_extended_auditing_policies" {
  description = "List of extended auditing policies for MSSQL databases."
  type = list(object({
    database_id                             = optional(string)
    enabled                                 = optional(bool, true)
    storage_endpoint                        = optional(string)
    retention_in_days                       = optional(number, 0)
    storage_account_access_key              = optional(string)
    storage_account_access_key_is_secondary = optional(bool, false)
    log_monitoring_enabled                  = optional(bool, true)
  }))
  default = []
}
######vulnerability_assessment_rule_baselines######
variable "vulnerability_assessment_rule_baselines" {
  type = list(object({
    server_vulnerability_assessment_id = optional(string)
    database_name                      = optional(string)
    rule_id                            = string
    baseline_name                      = optional(string, "default")
    baseline_results                   = list(list(string))
  }))
  default     = []
  description = "List of vulnerability assessment rule baselines for MS SQL databases."
}

variable "vulnerability_assessments" {
  type = list(object({
    server_security_alert_policy_id = optional(string)
    storage_container_path          = string
    storage_account_access_key      = optional(string)
    storage_container_sas_key       = optional(string)
    recurring_scans = optional(object({
      enabled                   = optional(bool)
      email_subscription_admins = optional(bool)
      emails                    = optional(list(string))
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

####elasticpool###
variable "elasticpool" {
  type = list(object({
    name                           = string
    resource_group_name            = optional(string)
    location                       = optional(string)
    server_name                    = optional(string)
    license_type                   = optional(string)
    max_size_gb                    = optional(number)
    zone_redundant                 = optional(bool)
    maintenance_configuration_name = optional(string)
    enclave_type                   = string
    sku = object({
      name     = string
      tier     = string
      capacity = number
      family   = optional(string)
    })
    per_database_settings = optional(object({
      min_capacity = number
      max_capacity = number
    }))
  }))
  default     = []
  description = "values for elasticpool"
}

####failover_group###
variable "failover_groups" {
  type = list(object({
    name                                      = string
    server_id                                 = string
    databases                                 = optional(set(string))
    readonly_endpoint_failover_policy_enabled = optional(bool, false)
    partner_server = object({
      id = string
    })
    read_write_endpoint_failover_policy = object({
      mode          = string           # Possible values: Automatic, Manual
      grace_minutes = optional(number) # Required only when mode is Automatic
    })
  }))
  default     = []
  description = "Values for configuring MSSQL Failover Groups"
}

###mssql_jobs###
variable "jobs" {
  type = list(object({
    name         = string
    job_agent_id = optional(string)
    description  = optional(string)
  }))
  default     = []
  description = "Values for configuring MSSQL Elastic Jobs"
}

###mssql_job_agents###
variable "job_agents" {
  type = list(object({
    name        = string
    location    = optional(string)
    database_id = optional(string)
    tags        = optional(map(string), {})
  }))
  default     = []
  description = "Values for configuring MSSQL Elastic Job Agents"
}

###mssql_job_credits###
variable "job_credentials" {
  type = list(object({
    name         = string
    job_agent_id = optional(string)
    username     = string
    password     = string
  }))
  default     = []
  description = "Values for configuring MSSQL Elastic Job Credentials"
}

###mssql_job_schedules###
variable "job_schedules" {
  type = list(object({
    job_id     = optional(string) # The ID of the Elastic Job
    type       = string           # Type of schedule, e.g., "Once" or "Recurring"
    enabled    = bool             # Whether the schedule is enabled
    start_time = optional(string) # Start time in RFC3339 format
    end_time   = optional(string) # End time in RFC3339 format (optional)
    interval   = optional(string) # Interval in ISO8601 duration format (e.g., "PT5M")
  }))
  default     = []
  description = "Configuration for MSSQL Elastic Job Schedules"
}

###mssql_outbound_firewall_rules###
variable "outbound_firewall_rules" {
  type = list(object({
    name      = string           # Fully Qualified Domain Name (FQDN) for the outbound rule
    server_id = optional(string) # The resource ID of the MSSQL server
  }))
  default     = []
  description = "Configuration for MSSQL SQL Outbound Firewall Rules"
}

###mssql_server_dns_alias##
variable "dns_aliases" {
  type = list(object({
    name            = string           # Name for the MSSQL Server DNS Alias
    mssql_server_id = optional(string) # The resource ID of the MSSQL server
  }))
  default     = []
  description = "Configuration for MSSQL Server DNS Aliases"
}

###mssql_server_extended_auditing_policies###
variable "extended_auditing_policies" {
  type = list(object({
    server_id                               = optional(string)       # The resource ID of the SQL Server
    enabled                                 = optional(bool)         # Whether to enable the extended auditing policy (optional, default: true)
    storage_endpoint                        = optional(string)       # The blob storage endpoint
    retention_in_days                       = optional(number)       # The number of days to retain logs (optional, default: 0)
    storage_account_access_key              = optional(string)       # The storage account access key (optional)
    storage_account_access_key_is_secondary = optional(bool)         # Whether to use the secondary key for storage account access (optional)
    log_monitoring_enabled                  = optional(bool)         # Enable monitoring in Azure Monitor (optional, default: true)
    storage_account_subscription_id         = optional(string)       # The subscription ID for the storage account (optional)
    predicate_expression                    = optional(string)       # The condition for the audit (optional)
    audit_actions_and_groups                = optional(list(string)) # The list of actions and action groups to audit (optional)
  }))
  default     = []
  description = "Configuration for MSSQL Server Extended Auditing Policies"
}

###mssql_server_microsoft_support_auditing_policies###
variable "microsoft_support_auditing_policies" {
  type = list(object({
    server_id                       = optional(string) # The resource ID of the SQL Server
    enabled                         = optional(bool)   # Whether to enable the auditing policy (optional, default: true)
    blob_storage_endpoint           = optional(string) # The blob storage endpoint to store auditing logs (optional)
    storage_account_access_key      = optional(string) # The storage account access key (optional)
    log_monitoring_enabled          = optional(bool)   # Enable logging to Azure Monitor (optional, default: true)
    storage_account_subscription_id = optional(string) # The subscription ID for the storage account (optional)
  }))
  default     = []
  description = "Configuration for MSSQL Server Microsoft Support Auditing Policies"
}

variable "transparent_data_encryption" {
  type = list(object({
    server_id             = optional(string) # The ID of the MSSQL server to apply transparent data encryption
    key_vault_key_id      = string           # Optional: The Key Vault Key ID for customer-managed keys
    managed_hsm_key_id    = string           # Optional: The Managed HSM Key ID for customer-managed keys
    auto_rotation_enabled = bool             # Optional: Whether to enable automatic key rotation (default: false)
  }))
  default     = []
  description = "Configuration for MSSQL Server Transparent Data Encryption (TDE)"
}
