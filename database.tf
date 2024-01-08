locals {

  databases_map = { for db in var.databases : db.suffix => db }

  databases_names_map = { for db in var.databases : db.suffix => azurecaf_name.self_database[db.suffix].result }

}

moved {
  from = azurecaf_name.self_database
  to   = azurecaf_name.self_database["01"]
}

resource "azurecaf_name" "self_database" {

  for_each = local.databases_map

  name          = each.key
  resource_type = "azurerm_mssql_database"
  prefixes      = var.caf_prefixes_main
  suffixes      = []
  use_slug      = true
  clean_input   = true
  separator     = ""
}

moved {
  from = azurerm_mssql_database.self
  to   = azurerm_mssql_database.self["01"]
}

resource "azurerm_mssql_database" "self" {

  for_each = local.databases_map

  name         = azurecaf_name.self_database[each.key].result
  server_id    = azurerm_mssql_server.primary.id
  collation    = each.value.collation
  license_type = each.value.license_type == "" ? null : each.value.license_type

  sku_name                    = each.value.sku_name
  min_capacity                = each.value.min_capacity
  zone_redundant              = each.value.zone_redundant
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  storage_account_type        = each.value.storage_account_type


  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy == null ? [] : [each.value.short_term_retention_policy]

    content {
      retention_days           = each.value.short_term_retention_policy.retention_days
      backup_interval_in_hours = each.value.short_term_retention_policy.backup_interval_in_hours
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention_policy == null ? [] : [each.value.long_term_retention_policy]

    content {
      weekly_retention  = each.value.long_term_retention_policy.weekly_retention
      monthly_retention = each.value.long_term_retention_policy.monthly_retention
      yearly_retention  = each.value.long_term_retention_policy.yearly_retention
      week_of_year      = each.value.long_term_retention_policy.week_of_year
    }
  }

  tags = {
    for n, v in merge(local.tags_main, { "description" = each.value.database_description }, each.value.custom_tags) : n => v if v != ""
  }

  lifecycle {
    prevent_destroy = true
  }
}
