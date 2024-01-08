locals {
  fog_databases = [for db in azurerm_mssql_database.self : db.id]
}

resource "azurecaf_name" "self_fog" {
  name          = format("%02d", var.instance_index)
  resource_type = "azurerm_sql_failover_group"
  prefixes      = var.caf_prefixes_main
  suffixes      = []
  use_slug      = true
  clean_input   = true
  separator     = ""
}

resource "azurerm_mssql_failover_group" "self" {
  count     = local.with_failover_group ? 1 : 0
  name      = azurecaf_name.self_fog.result
  server_id = azurerm_mssql_server.primary.id
  databases = local.fog_databases

  partner_server {
    id = azurerm_mssql_server.secondary[0].id
  }

  read_write_endpoint_failover_policy {
    mode          = var.sql_failover_group_policy.mode
    grace_minutes = var.sql_failover_group_policy.grace_minutes
  }

  tags = { for n, v in merge(local.tags_main, var.server_custom_tags) : n => v if v != "" }
}
