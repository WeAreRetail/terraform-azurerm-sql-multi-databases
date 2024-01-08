terraform {
  required_version = ">= 0.15.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.62.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.5"
    }
    sqlsso = {
      source  = "jason-johnson/sqlsso"
      version = "~> 1.0"
    }
  }
}
