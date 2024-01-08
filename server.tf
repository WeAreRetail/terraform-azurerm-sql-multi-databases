locals {
  primary_server_name = coalesce(var.server_custom_name, azurecaf_name.primary_server.result)
  server_tags_main    = { for n, v in merge(local.tags_main, { "description" = var.server_description }, var.server_custom_tags) : n => v if v != "" }
  server_tags_dr      = { for n, v in merge(local.tags_dr, { "description" = var.server_description }, var.server_custom_tags) : n => v if v != "" }
}

data "azuread_group" "admins" {
  display_name     = var.admin_group
  security_enabled = true
}

resource "random_password" "password" {
  length           = 16
  min_lower        = 1
  min_numeric      = 1
  min_special      = 2
  min_upper        = 1
  special          = true
  override_special = "_%#!"

  lifecycle {
    ignore_changes = all
  }
}

resource "azurecaf_name" "primary_server" {
  name          = format("%02d", var.instance_index)
  resource_type = "azurerm_mssql_server"
  prefixes      = var.caf_prefixes_main
  suffixes      = []
  use_slug      = true
  clean_input   = true
  separator     = ""
}

resource "azurecaf_name" "virtual_network_rule_primary" {
  count = length(var.sql_server_virtual_network_rules_main)

  name          = "${azurerm_mssql_server.primary.name}${count.index}"
  resource_type = "general"
  prefixes      = var.caf_prefixes_main
  suffixes      = []
  use_slug      = false
  clean_input   = true
  separator     = ""
}

resource "azurerm_mssql_server" "primary" {
  name                          = local.primary_server_name
  resource_group_name           = var.resource_group_name
  location                      = local.location
  version                       = "12.0"
  administrator_login           = "${local.primary_server_name}_admin"
  administrator_login_password  = random_password.password.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  connection_policy             = "Proxy"

  azuread_administrator {
    login_username              = var.admin_group
    object_id                   = data.azuread_group.admins.object_id
    azuread_authentication_only = true
  }

  tags = local.server_tags_main

  lifecycle {
    ignore_changes = [
      administrator_login,
      administrator_login_password, #Ignore change as it cannot be modified when "azuread_authentication_only = true" 
    ]
  }
}

resource "azurerm_mssql_firewall_rule" "primary_rules" {
  for_each = var.sql_server_firewall_rules

  server_id        = azurerm_mssql_server.primary.id
  name             = each.value["name"]
  start_ip_address = each.value["start"]
  end_ip_address   = each.value["end"]
}

resource "azurerm_mssql_virtual_network_rule" "primary" {
  count = length(var.sql_server_virtual_network_rules_main)

  name      = azurecaf_name.virtual_network_rule_primary[count.index].result
  server_id = azurerm_mssql_server.primary.id
  subnet_id = var.sql_server_virtual_network_rules_main[count.index]
}


resource "azurecaf_name" "secondary_server" {
  count         = local.with_failover_group ? 1 : 0
  name          = format("%02d", var.instance_index + 1)
  resource_type = "azurerm_mssql_server"
  prefixes      = var.caf_prefixes_dr
  suffixes      = []
  use_slug      = true
  clean_input   = true
  separator     = ""
}

resource "azurerm_mssql_server" "secondary" {
  count                         = local.with_failover_group ? 1 : 0
  name                          = azurecaf_name.secondary_server[0].result
  resource_group_name           = var.resource_group_name
  location                      = var.sql_failover_group_policy.location
  version                       = "12.0"
  administrator_login           = "${local.primary_server_name}_admin"
  administrator_login_password  = random_password.password.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  connection_policy             = "Proxy"

  azuread_administrator {
    login_username              = var.admin_group
    object_id                   = data.azuread_group.admins.object_id
    azuread_authentication_only = true
  }

  tags = local.server_tags_dr
}

resource "azurerm_mssql_firewall_rule" "secondary_rules" {
  for_each = local.with_failover_group ? var.sql_server_firewall_rules : {}

  server_id        = azurerm_mssql_server.secondary[0].id
  name             = each.value["name"]
  start_ip_address = each.value["start"]
  end_ip_address   = each.value["end"]
}

resource "azurecaf_name" "virtual_network_rule_secondary" {
  count = local.with_failover_group ? length(var.sql_server_virtual_network_rules_dr) : 0

  name          = "${azurerm_mssql_server.secondary[0].name}${count.index}"
  resource_type = "general"
  prefixes      = var.caf_prefixes_dr
  suffixes      = []
  use_slug      = false
  clean_input   = true
  separator     = ""
}

resource "azurerm_mssql_virtual_network_rule" "secondary" {
  count = local.with_failover_group ? length(var.sql_server_virtual_network_rules_dr) : 0

  name      = azurecaf_name.virtual_network_rule_secondary[count.index]
  server_id = azurerm_mssql_server.secondary[0].id
  subnet_id = var.sql_server_virtual_network_rules_dr[count.index]
}
