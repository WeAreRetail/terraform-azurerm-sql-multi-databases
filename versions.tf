terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }

    # 4.6.0 is the minimum version required for the azurerm provider: https://github.com/hashicorp/terraform-provider-azurerm/pull/27656
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.6.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.5"
    }
    sqlsso = {
      source  = "jason-johnson/sqlsso"
      version = "1.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}
