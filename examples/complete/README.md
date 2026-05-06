<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mssql"></a> [mssql](#module\_mssql) | ../../modules/mssql | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_id.rg_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westus"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Database name of the Azure SQL Database created. |
| <a name="output_firewall_rule_ids"></a> [firewall\_rule\_ids](#output\_firewall\_rule\_ids) | The IDs of the created MSSQL Firewall Rules. |
| <a name="output_mssql_server_extended_auditing_policy_ids"></a> [mssql\_server\_extended\_auditing\_policy\_ids](#output\_mssql\_server\_extended\_auditing\_policy\_ids) | The IDs of the created MSSQL Server Extended Auditing Policies. |
| <a name="output_mssql_server_fqdn"></a> [mssql\_server\_fqdn](#output\_mssql\_server\_fqdn) | Fully Qualified Domain Name (FQDN) of the Azure SQL Database created. |
| <a name="output_mssql_server_name"></a> [mssql\_server\_name](#output\_mssql\_server\_name) | Server name of the Azure SQL Database created. |
| <a name="output_mssql_server_security_alert_policy_ids"></a> [mssql\_server\_security\_alert\_policy\_ids](#output\_mssql\_server\_security\_alert\_policy\_ids) | The IDs of the MS SQL Server Security Alert Policies. |
| <a name="output_mssql_server_vulnerability_assessment_ids"></a> [mssql\_server\_vulnerability\_assessment\_ids](#output\_mssql\_server\_vulnerability\_assessment\_ids) | The IDs of the MS SQL Server Vulnerability Assessments. |
<!-- END_TF_DOCS -->
