<!-- BEGIN_TF_DOCS -->
# Azure Database Wrapper Module

This Terraform module serves as a universal wrapper for deploying either **Azure SQL (MSSQL)** or **PostgreSQL Flexible Server**. By specifying the `database_type`, you can toggle between the two engines while maintaining a consistent resource group and location context.

## Usage

### PostgreSQL Flexible Server
```hcl
module "database" {
  source            = "../../"
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
  source            = "../../"
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
| <a name="input_active_directory_administrators"></a> [active\_directory\_administrators](#input\_active\_directory\_administrators) | List of AD administrators for PostgreSQL Flexible Server. Each item defines an administrator. | <pre>list(object({<br/>    server_name         = optional(string)<br/>    resource_group_name = optional(string)<br/>    object_id           = optional(string)<br/>    tenant_id           = optional(string)<br/>    principal_name      = optional(string)<br/>    principal_type      = optional(string, "ServicePrincipal") # Default value<br/>  }))</pre> | `[]` | no |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | The Password associated with the administrator\_login for the PostgreSQL Server. | `string` | n/a | yes |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Authentication configuration, known in the API as Server Active Directory Administrator details | <pre>list(object({<br/>    password_auth_enabled         = bool<br/>    active_directory_auth_enabled = bool<br/>    tenant_id                     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_auto_grow_enabled"></a> [auto\_grow\_enabled](#input\_auto\_grow\_enabled) | (Optional) Enable or disable incremental automatic growth of database space. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is `true`. | `bool` | `true` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Backup retention days for the server, supported values are between 7 and 35 days. | `number` | `7` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | (Optional) The creation mode. Can be used to restore or replicate existing servers. Possible values are `Default`, `Replica`, `GeoRestore`, and `PointInTimeRestore`. Defaults to `Default.` | `string` | `"Default"` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | A map of customer managed key configurations. Each key must include key\_vault\_key\_id and primary\_user\_assigned\_identity\_id. | <pre>map(object({<br/>    key_vault_key_id                     = string<br/>    primary_user_assigned_identity_id    = string<br/>    geo_backup_key_vault_key_id          = optional(string)<br/>    geo_backup_user_assigned_identity_id = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_database_type"></a> [database\_type](#input\_database\_type) | Type of database to be created | `string` | n/a | yes |
| <a name="input_db_charset"></a> [db\_charset](#input\_db\_charset) | Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created. | `string` | `"UTF8"` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Note that Microsoft uses different notation - en-US instead of en\_US. Changing this forces a new resource to be created. | `string` | `"en_US.utf8"` | no |
| <a name="input_db_names"></a> [db\_names](#input\_db\_names) | The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | (Optional) The delegated subnet resource id used to create the server. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_firewall_rule_prefix"></a> [firewall\_rule\_prefix](#input\_firewall\_rule\_prefix) | Specifies prefix for firewall rule names. | `string` | `"firewall-"` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | The list of maps, describing firewall rules. Valid map items: name, start\_ip, end\_ip. | `list(map(string))` | `[]` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier. | `bool` | `true` | no |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | High availability configuration, The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant | <pre>list(object(<br/>    {<br/>      mode                      = optional(string)<br/>      standby_availability_zone = optional(string)<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Identity configuration, For type The only possible value is UserAssigned | <pre>list(object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window configuration, known in the API as Server Maintenance Window details | <pre>list(object({<br/>    day_of_week  = number<br/>    start_hour   = number<br/>    start_minute = number<br/>  }))</pre> | `[]` | no |
| <a name="input_point_in_time_restore_time_in_utc"></a> [point\_in\_time\_restore\_time\_in\_utc](#input\_point\_in\_time\_restore\_time\_in\_utc) | (Optional) Point in time restore time in UTC. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_postgresql_configurations"></a> [postgresql\_configurations](#input\_postgresql\_configurations) | List of PostgreSQL configurations to apply to the flexible server. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_postgresql_virtual_endpoints"></a> [postgresql\_virtual\_endpoints](#input\_postgresql\_virtual\_endpoints) | List of virtual endpoints to create for PostgreSQL Flexible Server replicas. | <pre>list(object({<br/>    name              = string<br/>    type              = string<br/>    source_server_id  = string<br/>    replica_server_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | (Optional) The private dns zone id used to create the server. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this server. Possible values are Enabled and Disabled. | `bool` | `false` | no |
| <a name="input_replication_role"></a> [replication\_role](#input\_replication\_role) | (Optional) The resource ID of the source PostgreSQL Flexible Server to be restored. Required when create\_mode is GeoRestore, PointInTimeRestore or Replica. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the PostgreSQL Server. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Specifies the name of the PostgreSQL Server. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | Specifies the version of PostgreSQL to use. Valid values are 11,12, 13, 14, 15 and 16. Changing this forces a new resource to be created. | `string` | `"15"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g.  B\_Standard\_B1ms, GP\_Standard\_D2s\_v3, MO\_Standard\_E4s\_v3). | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_source_server_id"></a> [source\_server\_id](#input\_source\_server\_id) | (Optional) The source server id for the PostgreSQL Flexible Server. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216 and 33553408. | `number` | `32768` | no |
| <a name="input_storage_tier"></a> [storage\_tier](#input\_storage\_tier) | Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80 | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to set on every taggable resources. Empty by default. | `map(string)` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_active_directory_administrators_id"></a> [active\_directory\_administrators\_id](#output\_active\_directory\_administrators\_id) | The ID of the PostgreSQL Flexible Server Active Directory Administrator. |
| <a name="output_administrator_login"></a> [administrator\_login](#output\_administrator\_login) | The Administrator login for the PostgreSQL Server |
| <a name="output_administrator_password"></a> [administrator\_password](#output\_administrator\_password) | The Password associated with the `administrator_login` for the PostgreSQL Server |
| <a name="output_database_ids"></a> [database\_ids](#output\_database\_ids) | The list of all database resource ids |
| <a name="output_firewall_rule_ids"></a> [firewall\_rule\_ids](#output\_firewall\_rule\_ids) | The list of all firewall rule resource ids |
| <a name="output_postgresql_configurations_id"></a> [postgresql\_configurations\_id](#output\_postgresql\_configurations\_id) | The ID of the PostgreSQL Flexible Server Configuration. |
| <a name="output_server_fqdn"></a> [server\_fqdn](#output\_server\_fqdn) | The fully qualified domain name (FQDN) of the PostgreSQL server |
| <a name="output_server_id"></a> [server\_id](#output\_server\_id) | The resource id of the PostgreSQL server |
| <a name="output_server_name"></a> [server\_name](#output\_server\_name) | The name of the PostgreSQL server |
| <a name="output_virtual_endpoints_id"></a> [virtual\_endpoints\_id](#output\_virtual\_endpoints\_id) | The ID of the PostgreSQL Flexible Server Virtual Endpoint. |

---
*Generated by terraform-docs*
<!-- END_TF_DOCS -->