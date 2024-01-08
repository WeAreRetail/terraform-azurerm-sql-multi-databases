locals {

  tags_main = { for n, v in var.tags_main : n => v if n != "description" }
  tags_dr   = { for n, v in var.tags_dr : n => v if n != "description" }

  location            = coalesce(var.custom_location, data.azurerm_resource_group.parent_group_main.location)
  with_failover_group = var.sql_failover_group_policy != null
}

data "azurerm_resource_group" "parent_group_main" {
  name = var.resource_group_name
}
