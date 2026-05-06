<!-- BEGIN_TF_DOCS -->
# Azure Database Wrapper Module

This Terraform module serves as a universal wrapper for deploying either **Azure SQL (MSSQL)** or **PostgreSQL Flexible Server**. By specifying the `database_type`, you can toggle between the two engines while maintaining a consistent resource group and location context.

## Usage

### PostgreSQL Flexible Server
```hcl
module "database" {
  source            = "Tenets/azure-database/azurerm"
  database_type     = "postgresql"
  resource_group_name = "my-rg"
  server_name       = "my-postgres-server"
  location          = "West Europe"
  # ... other postgres-specific variables
}
```

### Azure SQL (MSSQL) Database
```hcl
module "database" {
  source            = "Tenets/azure-database/azurerm"
  database_type     = "mssql"
  resource_group_name = "my-rg"
  server_name       = "my-mssql-server"
  location          = "West Europe"
  # ... other mssql-specific variables
}
```



## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | 2.2.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Submodule Reference

This module delegates to the following specialized submodules. You can find engine-specific details in their respective documentation:

*   [**PostgreSQL Submodule**](./modules/postgresql/README.md)
*   [**MSSQL Submodule**](./modules/mssql/README.md)

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The Administrator Login for the mssql Server. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | The Password associated with the administrator\_login for the PostgreSQL Server. | `string` | `null` | no |
| <a name="input_auto_pause_delay_in_minutes"></a> [auto\_pause\_delay\_in\_minutes](#input\_auto\_pause\_delay\_in\_minutes) | Time in minutes after which database is automatically paused. | `number` | `-1` | no |
| <a name="input_azuread_administrator"></a> [azuread\_administrator](#input\_azuread\_administrator) | Authentication configuration, known in the API as Server Active Directory Administrator details | <pre>list(object({<br/>    login_username              = string<br/>    object_id                   = string<br/>    tenant_id                   = string<br/>    azuread_authentication_only = optional(bool, false) #  When true, the administrator_login and administrator_login_password properties can be omitted.<br/>  }))</pre> | `[]` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | Specifies the collation of the database. | `string` | `"SQL_Latin1_General_CP1_CI_AS"` | no |
| <a name="input_connection_policy"></a> [connection\_policy](#input\_connection\_policy) | The connection policy the server will use. Possible values are Default, Proxy, and Redirect | `string` | `"Default"` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. | `string` | `"Default"` | no |
| <a name="input_creation_source_database_id"></a> [creation\_source\_database\_id](#input\_creation\_source\_database\_id) | The ID of the source database from which to create the new database. This should only be used for databases with create\_mode values that use another database as reference. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_database_extended_auditing_policies"></a> [database\_extended\_auditing\_policies](#input\_database\_extended\_auditing\_policies) | List of extended auditing policies for MSSQL databases. | <pre>list(object({<br/>    database_id                             = optional(string)<br/>    enabled                                 = optional(bool, true)<br/>    storage_endpoint                        = optional(string)<br/>    retention_in_days                       = optional(number, 0)<br/>    storage_account_access_key              = optional(string)<br/>    storage_account_access_key_is_secondary = optional(bool, false)<br/>    log_monitoring_enabled                  = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_database_type"></a> [database\_type](#input\_database\_type) | Type of database to be created | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the MS SQL Database. | `string` | n/a | yes |
| <a name="input_dns_aliases"></a> [dns\_aliases](#input\_dns\_aliases) | Configuration for MSSQL Server DNS Aliases | <pre>list(object({<br/>    name            = string           # Name for the MSSQL Server DNS Alias<br/>    mssql_server_id = optional(string) # The resource ID of the MSSQL server<br/>  }))</pre> | `[]` | no |
| <a name="input_elastic_pool_id"></a> [elastic\_pool\_id](#input\_elastic\_pool\_id) | Specifies the ID of the elastic pool containing this database. | `string` | `null` | no |
| <a name="input_elasticpool"></a> [elasticpool](#input\_elasticpool) | values for elasticpool | <pre>list(object({<br/>    name                           = string<br/>    resource_group_name            = optional(string)<br/>    location                       = optional(string)<br/>    server_name                    = optional(string)<br/>    license_type                   = optional(string)<br/>    max_size_gb                    = optional(number)<br/>    zone_redundant                 = optional(bool)<br/>    maintenance_configuration_name = optional(string)<br/>    enclave_type                   = string<br/>    sku = object({<br/>      name     = string<br/>      tier     = string<br/>      capacity = number<br/>      family   = optional(string)<br/>    })<br/>    per_database_settings = optional(object({<br/>      min_capacity = number<br/>      max_capacity = number<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_enclave_type"></a> [enclave\_type](#input\_enclave\_type) | Possible values are Default or VBS | `string` | `"Default"` | no |
| <a name="input_extended_auditing_policies"></a> [extended\_auditing\_policies](#input\_extended\_auditing\_policies) | Configuration for MSSQL Server Extended Auditing Policies | <pre>list(object({<br/>    server_id                               = optional(string)       # The resource ID of the SQL Server<br/>    enabled                                 = optional(bool)         # Whether to enable the extended auditing policy (optional, default: true)<br/>    storage_endpoint                        = optional(string)       # The blob storage endpoint<br/>    retention_in_days                       = optional(number)       # The number of days to retain logs (optional, default: 90)<br/>    storage_account_access_key              = optional(string)       # The storage account access key (optional)<br/>    storage_account_access_key_is_secondary = optional(bool)         # Whether to use the secondary key for storage account access (optional)<br/>    log_monitoring_enabled                  = optional(bool)         # Enable monitoring in Azure Monitor (optional, default: true)<br/>    storage_account_subscription_id         = optional(string)       # The subscription ID for the storage account (optional)<br/>    predicate_expression                    = optional(string)       # The condition for the audit (optional)<br/>    audit_actions_and_groups                = optional(list(string)) # The list of actions and action groups to audit (optional)<br/>  }))</pre> | `[]` | no |
| <a name="input_failover_groups"></a> [failover\_groups](#input\_failover\_groups) | Values for configuring MSSQL Failover Groups | <pre>list(object({<br/>    name                                      = string<br/>    server_id                                 = string<br/>    databases                                 = optional(set(string))<br/>    readonly_endpoint_failover_policy_enabled = optional(bool, false)<br/>    partner_server = object({<br/>      id = string<br/>    })<br/>    read_write_endpoint_failover_policy = object({<br/>      mode          = string           # Possible values: Automatic, Manual<br/>      grace_minutes = optional(number) # Required only when mode is Automatic<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Values for configuring MSSQL Firewall Rules | <pre>list(object({<br/>    name             = string<br/>    server_id        = optional(string)<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_geo_backup_enabled"></a> [geo\_backup\_enabled](#input\_geo\_backup\_enabled) | Specifies if geo backup is enabled for this database. | `bool` | `true` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Identity block for the database. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_import"></a> [import](#input\_import) | Import block for database creation. | <pre>object({<br/>    storage_uri                  = string<br/>    storage_key                  = string<br/>    storage_key_type             = string<br/>    administrator_login          = string<br/>    administrator_login_password = string<br/>    authentication_type          = string<br/>  })</pre> | `null` | no |
| <a name="input_job_agents"></a> [job\_agents](#input\_job\_agents) | Values for configuring MSSQL Elastic Job Agents | <pre>list(object({<br/>    name        = string<br/>    location    = optional(string)<br/>    database_id = optional(string)<br/>    tags        = optional(map(string), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_job_credentials"></a> [job\_credentials](#input\_job\_credentials) | Values for configuring MSSQL Elastic Job Credentials | <pre>list(object({<br/>    name         = string<br/>    job_agent_id = optional(string)<br/>    username     = string<br/>    password     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_job_schedules"></a> [job\_schedules](#input\_job\_schedules) | Configuration for MSSQL Elastic Job Schedules | <pre>list(object({<br/>    job_id     = optional(string) # The ID of the Elastic Job<br/>    type       = string           # Type of schedule, e.g., "Once" or "Recurring"<br/>    enabled    = bool             # Whether the schedule is enabled<br/>    start_time = optional(string) # Start time in RFC3339 format<br/>    end_time   = optional(string) # End time in RFC3339 format (optional)<br/>    interval   = optional(string) # Interval in ISO8601 duration format (e.g., "PT5M")<br/>  }))</pre> | `[]` | no |
| <a name="input_jobs"></a> [jobs](#input\_jobs) | Values for configuring MSSQL Elastic Jobs | <pre>list(object({<br/>    name         = string<br/>    job_agent_id = optional(string)<br/>    description  = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_ledger_enabled"></a> [ledger\_enabled](#input\_ledger\_enabled) | A boolean that specifies if this is a ledger database. Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the license type applied to this database. | `string` | `"LicenseIncluded"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the database and server are created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_long_term_retention_policy"></a> [long\_term\_retention\_policy](#input\_long\_term\_retention\_policy) | Long-term retention policy block. | <pre>object({<br/>    weekly_retention  = string<br/>    monthly_retention = string<br/>    yearly_retention  = string<br/>    week_of_year      = number<br/>  })</pre> | `null` | no |
| <a name="input_maintenance_configuration_name"></a> [maintenance\_configuration\_name](#input\_maintenance\_configuration\_name) | The name of the Public Maintenance Configuration window to apply to the database. | `string` | `"SQL_Default"` | no |
| <a name="input_max_size_gb"></a> [max\_size\_gb](#input\_max\_size\_gb) | The max size of the database in gigabytes. | `number` | `20` | no |
| <a name="input_microsoft_support_auditing_policies"></a> [microsoft\_support\_auditing\_policies](#input\_microsoft\_support\_auditing\_policies) | Configuration for MSSQL Server Microsoft Support Auditing Policies | <pre>list(object({<br/>    server_id                       = optional(string) # The resource ID of the SQL Server<br/>    enabled                         = optional(bool)   # Whether to enable the auditing policy (optional, default: true)<br/>    blob_storage_endpoint           = optional(string) # The blob storage endpoint to store auditing logs (optional)<br/>    storage_account_access_key      = optional(string) # The storage account access key (optional)<br/>    log_monitoring_enabled          = optional(bool)   # Enable logging to Azure Monitor (optional, default: true)<br/>    storage_account_subscription_id = optional(string) # The subscription ID for the storage account (optional)<br/>  }))</pre> | `[]` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimal capacity that database will always have allocated, if not paused. | `number` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum supported TLS version. Possible values are 1.0, 1.1, and 1.2 | `string` | `"1.2"` | no |
| <a name="input_outbound_firewall_rules"></a> [outbound\_firewall\_rules](#input\_outbound\_firewall\_rules) | Configuration for MSSQL SQL Outbound Firewall Rules | <pre>list(object({<br/>    name      = string           # Fully Qualified Domain Name (FQDN) for the outbound rule<br/>    server_id = optional(string) # The resource ID of the MSSQL server<br/>  }))</pre> | `[]` | no |
| <a name="input_outbound_network_restriction_enabled"></a> [outbound\_network\_restriction\_enabled](#input\_outbound\_network\_restriction\_enabled) | Whether outbound network traffic is restricted for this server. Defaults to false | `bool` | `false` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this server. Defaults to true. | `bool` | `true` | no |
| <a name="input_read_replica_count"></a> [read\_replica\_count](#input\_read\_replica\_count) | The number of readonly secondary replicas associated with the database to which readonly application intent connections may be routed. This property is only settable for Hyperscale edition databases. | `number` | `null` | no |
| <a name="input_read_scale"></a> [read\_scale](#input\_read\_scale) | If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. | `bool` | `false` | no |
| <a name="input_recover_database_id"></a> [recover\_database\_id](#input\_recover\_database\_id) | The ID of the database to be recovered. This property is only applicable when the create\_mode is Recovery. | `string` | `null` | no |
| <a name="input_recover_point_id"></a> [recover\_point\_id](#input\_recover\_point\_id) | The ID of the Recovery Services Recovery Point Id to be restored. This property is only applicable when the create\_mode is Recovery. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default resource group name that the database will be created in. | `string` | n/a | yes |
| <a name="input_restore_dropped_database_id"></a> [restore\_dropped\_database\_id](#input\_restore\_dropped\_database\_id) | The ID of the database to be restored. This property is only applicable when the create\_mode is Restore. | `string` | `null` | no |
| <a name="input_restore_long_term_retention_backup_id"></a> [restore\_long\_term\_retention\_backup\_id](#input\_restore\_long\_term\_retention\_backup\_id) | The ID of the long term retention backup to be restored. This property is only applicable when the create\_mode is RestoreLongTermRetentionBackup. | `string` | `null` | no |
| <a name="input_restore_point_in_time"></a> [restore\_point\_in\_time](#input\_restore\_point\_in\_time) | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. | `string` | `null` | no |
| <a name="input_sample_name"></a> [sample\_name](#input\_sample\_name) | Specifies the name of the sample schema to apply when creating this database. Possible value is AdventureWorksLT. | `string` | `null` | no |
| <a name="input_secondary_type"></a> [secondary\_type](#input\_secondary\_type) | How do you want your replica to be made? Valid values include Geo and Named. Defaults to Geo. | `string` | `"Geo"` | no |
| <a name="input_security_alert_policies"></a> [security\_alert\_policies](#input\_security\_alert\_policies) | List of security alert policies to configure for MS SQL Server. | <pre>list(object({<br/>    resource_group_name        = optional(string)<br/>    server_name                = optional(string)<br/>    state                      = string //Possible values are Disabled, Enabled and New.<br/>    storage_endpoint           = optional(string)<br/>    storage_account_access_key = optional(string)<br/>    disabled_alerts            = optional(list(string)) // Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action.<br/>    email_account_admins       = optional(bool)<br/>    email_addresses            = optional(list(string))<br/>    retention_days             = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Specifies the name of the mssql Server. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). | `string` | `"12.0"` | no |
| <a name="input_short_term_retention_policy"></a> [short\_term\_retention\_policy](#input\_short\_term\_retention\_policy) | Short-term retention policy block. | <pre>object({<br/>    retention_days = number<br/>  })</pre> | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the name of the SKU used by the database. For example, GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. | `string` | `null` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone. Defaults to Geo  . | `string` | `"Geo"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_threat_detection_policy"></a> [threat\_detection\_policy](#input\_threat\_detection\_policy) | Threat detection policy block. | <pre>object({<br/>    state                      = string<br/>    disabled_alerts            = list(string)<br/>    email_account_admins       = string<br/>    email_addresses            = list(string)<br/>    retention_days             = number<br/>    storage_account_access_key = string<br/>    storage_endpoint           = string<br/>  })</pre> | `null` | no |
| <a name="input_transparent_data_encryption"></a> [transparent\_data\_encryption](#input\_transparent\_data\_encryption) | Configuration for MSSQL Server Transparent Data Encryption (TDE) | <pre>list(object({<br/>    server_id             = optional(string) # The ID of the MSSQL server to apply transparent data encryption<br/>    key_vault_key_id      = string           # Optional: The Key Vault Key ID for customer-managed keys<br/>    managed_hsm_key_id    = string           # Optional: The Managed HSM Key ID for customer-managed keys<br/>    auto_rotation_enabled = bool             # Optional: Whether to enable automatic key rotation (default: false)<br/>  }))</pre> | `[]` | no |
| <a name="input_transparent_data_encryption_enabled"></a> [transparent\_data\_encryption\_enabled](#input\_transparent\_data\_encryption\_enabled) | Whether or not transparent data encryption is enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_transparent_data_encryption_key_automatic_rotation_enabled"></a> [transparent\_data\_encryption\_key\_automatic\_rotation\_enabled](#input\_transparent\_data\_encryption\_key\_automatic\_rotation\_enabled) | Whether or not automatic key rotation is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_transparent_data_encryption_key_vault_key_id"></a> [transparent\_data\_encryption\_key\_vault\_key\_id](#input\_transparent\_data\_encryption\_key\_vault\_key\_id) | The ID of the Azure Key Vault key used to encrypt the data at rest. (e.g. 'https://<YourVaultName>.vault.azure.net/keys/<YourKeyName>/<YourKeyVersion>) to be used as the customer-managed key to encrypt the data at rest for the server. | `string` | `null` | no |
| <a name="input_vulnerability_assessment_rule_baselines"></a> [vulnerability\_assessment\_rule\_baselines](#input\_vulnerability\_assessment\_rule\_baselines) | List of vulnerability assessment rule baselines for MS SQL databases. | <pre>list(object({<br/>    server_vulnerability_assessment_id = optional(string)<br/>    database_name                      = optional(string)<br/>    rule_id                            = string<br/>    baseline_name                      = optional(string, "default")<br/>    baseline_results                   = list(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_vulnerability_assessments"></a> [vulnerability\_assessments](#input\_vulnerability\_assessments) | List of vulnerability assessments to configure for MS SQL Server. | <pre>list(object({<br/>    server_security_alert_policy_id = optional(string)<br/>    storage_container_path          = string<br/>    storage_account_access_key      = optional(string)<br/>    storage_container_sas_key       = optional(string)<br/>    recurring_scans = optional(object({<br/>      enabled                   = optional(bool)<br/>      email_subscription_admins = optional(bool)<br/>      emails                    = optional(list(string))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Whether or not this database is zone redundant. | `bool` | `false` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_azurerm_mssql_elasticpool_id"></a> [azurerm\_mssql\_elasticpool\_id](#output\_azurerm\_mssql\_elasticpool\_id) | The ID of the MS SQL Server Elastic Pool. |
| <a name="output_connection_string"></a> [connection\_string](#output\_connection\_string) | Connection string for the Azure SQL Database created. |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Database name of the Azure SQL Database created. |
| <a name="output_failover_group_ids"></a> [failover\_group\_ids](#output\_failover\_group\_ids) | The IDs of the created MSSQL Failover Groups. |
| <a name="output_firewall_rule_ids"></a> [firewall\_rule\_ids](#output\_firewall\_rule\_ids) | The IDs of the created MSSQL Firewall Rules. |
| <a name="output_job_agent_ids"></a> [job\_agent\_ids](#output\_job\_agent\_ids) | The IDs of the created MSSQL Elastic Job Agents. |
| <a name="output_job_credential_ids"></a> [job\_credential\_ids](#output\_job\_credential\_ids) | The IDs of the created MSSQL Elastic Job Credentials. |
| <a name="output_job_ids"></a> [job\_ids](#output\_job\_ids) | The IDs of the created MSSQL Elastic Jobs. |
| <a name="output_mssql_job_schedule_ids"></a> [mssql\_job\_schedule\_ids](#output\_mssql\_job\_schedule\_ids) | The IDs of the created MSSQL Job Schedules. |
| <a name="output_mssql_outbound_firewall_rule_ids"></a> [mssql\_outbound\_firewall\_rule\_ids](#output\_mssql\_outbound\_firewall\_rule\_ids) | The IDs of the created MSSQL Outbound Firewall Rules. |
| <a name="output_mssql_server_dns_alias_dns_records"></a> [mssql\_server\_dns\_alias\_dns\_records](#output\_mssql\_server\_dns\_alias\_dns\_records) | The fully qualified DNS records for the created MSSQL Server DNS Aliases. |
| <a name="output_mssql_server_dns_alias_ids"></a> [mssql\_server\_dns\_alias\_ids](#output\_mssql\_server\_dns\_alias\_ids) | The IDs of the created MSSQL Server DNS Aliases. |
| <a name="output_mssql_server_extended_auditing_policy_ids"></a> [mssql\_server\_extended\_auditing\_policy\_ids](#output\_mssql\_server\_extended\_auditing\_policy\_ids) | The IDs of the created MSSQL Server Extended Auditing Policies. |
| <a name="output_mssql_server_fqdn"></a> [mssql\_server\_fqdn](#output\_mssql\_server\_fqdn) | Fully Qualified Domain Name (FQDN) of the Azure SQL Database created. |
| <a name="output_mssql_server_location"></a> [mssql\_server\_location](#output\_mssql\_server\_location) | Location of the Azure SQL Database created. |
| <a name="output_mssql_server_microsoft_support_auditing_policy_ids"></a> [mssql\_server\_microsoft\_support\_auditing\_policy\_ids](#output\_mssql\_server\_microsoft\_support\_auditing\_policy\_ids) | The IDs of the created MSSQL Server Microsoft Support Auditing Policies. |
| <a name="output_mssql_server_name"></a> [mssql\_server\_name](#output\_mssql\_server\_name) | Server name of the Azure SQL Database created. |
| <a name="output_mssql_server_security_alert_policy_ids"></a> [mssql\_server\_security\_alert\_policy\_ids](#output\_mssql\_server\_security\_alert\_policy\_ids) | The IDs of the MS SQL Server Security Alert Policies. |
| <a name="output_mssql_server_tde_ids"></a> [mssql\_server\_tde\_ids](#output\_mssql\_server\_tde\_ids) | The IDs of the created MSSQL Server Transparent Data Encryption resources. |
| <a name="output_mssql_server_version"></a> [mssql\_server\_version](#output\_mssql\_server\_version) | Version the Azure SQL Database created. |
| <a name="output_mssql_server_vulnerability_assessment_ids"></a> [mssql\_server\_vulnerability\_assessment\_ids](#output\_mssql\_server\_vulnerability\_assessment\_ids) | The IDs of the MS SQL Server Vulnerability Assessments. |

---
*Generated by terraform-docs*
<!-- END_TF_DOCS -->