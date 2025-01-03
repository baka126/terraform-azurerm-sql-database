data "azurerm_client_config" "current" {}
data "azuread_service_principal" "this" {
  object_id = data.azurerm_client_config.current.object_id
}
