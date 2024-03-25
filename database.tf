locals {

  databases_map = { for db in var.databases : db.suffix =>
    {
      license_type         = db.license_type == "" ? null : db.license_type
      suffix               = db.suffix
      database_description = db.database_description
      collation            = db.collation
      sku_name             = db.sku_name

      min_capacity                = can(regex(".*_S_.*", db.sku_name)) ? db.min_capacity : null                # Only for Serverless SKU
      auto_pause_delay_in_minutes = can(regex(".*_S_.*", db.sku_name)) ? db.auto_pause_delay_in_minutes : null # Only for Serverless SKU

      zone_redundant       = db.zone_redundant
      storage_account_type = db.storage_account_type

      custom_tags = db.custom_tags

      short_term_retention_policy = db.short_term_retention_policy
      long_term_retention_policy  = db.long_term_retention_policy

      user_groups = db.user_groups
      read_groups = db.read_groups

      # Technical SKU properties
      is_free              = can(regex("Free", db.sku_name))      # Free SKU (Example: "Free")
      is_standard          = can(regex("^S\\d+$", db.sku_name))   # Standard SKU (Example: "S0")
      is_premium           = can(regex("^P\\d+$", db.sku_name))   # Premium SKU (Example: "P1")
      is_data_warehouse    = can(regex("^DW\\d+c$", db.sku_name)) # DataWarehouse SKU (Example: "DW100c")
      is_stretch           = can(regex("^DS\\d+$", db.sku_name))  # DataWarehouse SKU (Example: "DS100")
      is_serverless        = can(regex(".*_S_.*", db.sku_name))   # Serverless SKU (Example: "GP_S_Gen5_2")
      is_hyperscale        = can(regex("^HS_.*", db.sku_name))    # Hyperscale SKU (Example: "HS_Gen5_2")
      is_general_purpose   = can(regex("^GP_.*", db.sku_name))    # General Purpose SKU (Example: "GP_Gen5_2")
      is_business_critical = can(regex("^BC_.*", db.sku_name))    # Business Critical SKU (Example: "BC_Gen5_2")
    }
  }

  databases_names_map     = { for db in var.databases : db.suffix => azurecaf_name.self_database[db.suffix].result }
  databases_configuration = { for db in local.databases_map : db.suffix => merge({ name = azurecaf_name.self_database[db.suffix].result }, db) }

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


resource "azurerm_mssql_database" "self" {

  for_each = local.databases_map

  name         = azurecaf_name.self_database[each.key].result
  server_id    = azurerm_mssql_server.primary.id
  collation    = each.value.collation
  license_type = each.value.license_type

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
