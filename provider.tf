################################################################################
# Defind the Resource Provider
################################################################################
provider "azurerm" {

  # Configuration options
  features {} #This is required for v4 of the provider even if empty or plan will fail. This allows different users to select the behaviour they require.
  use_oidc = true
}
provider "azuread" {
  # Required for Azure AD interactions, if needed in the module
}
