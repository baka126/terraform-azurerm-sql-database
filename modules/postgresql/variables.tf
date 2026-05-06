variable "database_type" {
  type        = string
  description = "Type of database to be created"

  validation {
    condition     = contains(["mssql", "postgresql"], var.database_type)
    error_message = "Valid values for database_type are 'mssql' or 'postgresql'."
  }
}
variable "administrator_login" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login for the PostgreSQL Server."
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the PostgreSQL Server. Changing this forces a new resource to be created."
}

variable "server_name" {
  type        = string
  description = "Specifies the name of the PostgreSQL Server. Changing this forces a new resource to be created."
}

variable "point_in_time_restore_time_in_utc" {
  type        = string
  default     = null
  description = "(Optional) Point in time restore time in UTC. Changing this forces a new resource to be created."
}

variable "zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located."

}

variable "replication_role" {
  type        = string
  default     = null
  description = " (Optional) The resource ID of the source PostgreSQL Flexible Server to be restored. Required when create_mode is GeoRestore, PointInTimeRestore or Replica."
}

variable "source_server_id" {
  type        = string
  default     = null
  description = "(Optional) The source server id for the PostgreSQL Flexible Server. Changing this forces a new resource to be created."

}

variable "auto_grow_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable or disable incremental automatic growth of database space. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is `true`."
}

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
}

variable "create_mode" {
  type        = string
  default     = "Default"
  description = "(Optional) The creation mode. Can be used to restore or replicate existing servers. Possible values are `Default`, `Replica`, `GeoRestore`, and `PointInTimeRestore`. Defaults to `Default.`"
  nullable    = false
}

variable "delegated_subnet_id" {
  type        = string
  default     = null
  description = "(Optional) The delegated subnet resource id used to create the server. Changing this forces a new resource to be created."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "(Optional) The private dns zone id used to create the server. Changing this forces a new resource to be created."
}



variable "db_charset" {
  type        = string
  default     = "UTF8"
  description = "Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created."
}

variable "db_collation" {
  type        = string
  default     = "en_US.utf8"
  description = "Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Note that Microsoft uses different notation - en-US instead of en_US. Changing this forces a new resource to be created."
}

variable "db_names" {
  type        = list(string)
  default     = []
  description = "The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created."
}

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

variable "geo_redundant_backup_enabled" {
  type        = bool
  default     = true
  description = "Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier."
}



variable "postgresql_configurations" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "List of PostgreSQL configurations to apply to the flexible server."
}


variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether or not public network access is allowed for this server. Possible values are Enabled and Disabled."
}

variable "server_version" {
  type        = string
  default     = "15"
  description = "Specifies the version of PostgreSQL to use. Valid values are 11,12, 13, 14, 15 and 16. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g.  B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)."
}

variable "storage_mb" {
  type        = number
  default     = 32768
  description = "The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216 and 33553408."
}

variable "storage_tier" {
  type        = string
  description = "Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80"
  default     = null
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to set on every taggable resources. Empty by default."
}

variable "authentication" {
  type = list(object({
    password_auth_enabled         = bool
    active_directory_auth_enabled = bool
    tenant_id                     = string
  }))
  default     = []
  description = "Authentication configuration, known in the API as Server Active Directory Administrator details"

}

variable "customer_managed_key" {
  description = "A map of customer managed key configurations. Each key must include key_vault_key_id and primary_user_assigned_identity_id."
  type = map(object({
    key_vault_key_id                     = string
    primary_user_assigned_identity_id    = string
    geo_backup_key_vault_key_id          = optional(string)
    geo_backup_user_assigned_identity_id = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, value in var.customer_managed_key :
      value.key_vault_key_id != "" && value.primary_user_assigned_identity_id != ""
    ])
    error_message = "Each customer_managed_key must include both key_vault_key_id and primary_user_assigned_identity_id."
  }
}

variable "high_availability" {
  type = list(object(
    {
      mode                      = optional(string)
      standby_availability_zone = optional(string)
    }
  ))
  default     = []
  description = "High availability configuration, The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant"
}

variable "identity" {
  type = list(object({
    type         = string
    identity_ids = list(string)
  }))
  default     = []
  description = "Identity configuration, For type The only possible value is UserAssigned"
}

variable "maintenance_window" {
  type = list(object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  }))
  default     = []
  description = "Maintenance window configuration, known in the API as Server Maintenance Window details"
}

variable "postgresql_virtual_endpoints" {
  type = list(object({
    name              = string
    type              = string
    source_server_id  = string
    replica_server_id = string
  }))
  default     = []
  description = "List of virtual endpoints to create for PostgreSQL Flexible Server replicas."
}

####active directory####
variable "active_directory_administrators" {
  type = list(object({
    server_name         = optional(string)
    resource_group_name = optional(string)
    object_id           = optional(string)
    tenant_id           = optional(string)
    principal_name      = optional(string)
    principal_type      = optional(string, "ServicePrincipal") # Default value
  }))
  default     = []
  description = "List of AD administrators for PostgreSQL Flexible Server. Each item defines an administrator."
}
