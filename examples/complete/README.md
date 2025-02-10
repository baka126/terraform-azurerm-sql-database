<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.16.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.16.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mssql"></a> [mssql](#module\_mssql) | ../../modules/mssql | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.16.0/docs/resources/resource_group) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.16.0/docs/resources/storage_account) | resource |
| [random_id.rg_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westus"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mssql_name"></a> [mssql\_name](#output\_mssql\_name) | The name of the MS SQL Server |
<!-- END_TF_DOCS -->