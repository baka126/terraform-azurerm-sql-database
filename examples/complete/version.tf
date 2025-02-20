terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.3"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
  }
}
