variable "database_type" {
  type = string
  description = "Type of database to be created"

  validation {
    condition = contains(["mysql", "postgresql"], var.database_type)
    error_message = "Valid values for database_type are 'mysql' or 'postgresql'."
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

variable "creation_source_server_id" {
  type        = string
  default     = null
  description = "(Optional) For creation modes other than `Default`, the source server ID to use."
}

variable "db_charset" {
  type        = string
  default     = "UTF8"
  description = "Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created."
}

variable "db_collation" {
  type        = string
  default     = "English_United States.1252"
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

variable "infrastructure_encryption_enabled" {
  type        = bool
  default     = true
  description = "Whether or not infrastructure is encrypted for this server"
}

variable "postgresql_configurations" {
  type        = map(string)
  default     = {}
  description = "A map with PostgreSQL configurations to enable."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether or not public network access is allowed for this server. Possible values are Enabled and Disabled."
}

variable "server_version" {
  type        = string
  default     = "9.5"
  description = "Specifies the version of PostgreSQL to use. Valid values are `9.5`, `9.6`, `10.0`, `10.2` and `11`. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type        = string
  default     = "GP_Gen5_4"
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
}

variable "storage_mb" {
  type        = number
  default     = 102400
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
}

variable "storage_tier" {
  type        = string
  description = "Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to set on every taggable resources. Empty by default."
}

variable "authentication" {
  type = object(
    {
      active_directory_auth_enabled = optional(bool)
      password_auth_enabled         = optional(bool)
      tenant_id                     = optional(string)
    }
  )
  default     = null
  description = "Authentication configuration, known in the API as Server Active Directory Administrator details"
  
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether enable tracing tags that generated by BridgeCrew Yor."
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_prefix" {
  type        = string
  default     = "avm_"
  description = "Default prefix for generated tracing tags"
  nullable    = false
}

variable "vnet_rule_name_prefix" {
  type        = string
  default     = "postgresql-vnet-rule-"
  description = "Specifies prefix for vnet rule names."
}

variable "vnet_rules" {
  type        = list(map(string))
  default     = []
  description = "The list of maps, describing vnet rules. Valud map items: name, subnet_id."
}