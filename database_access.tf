locals {

  owners_flatten = flatten([for db in var.databases :
    [for user_group in db.user_groups : {
      db : db
      user_group : user_group
  }]])

  owners_map = { for owner in local.owners_flatten : "${owner.user_group}_${owner.db.suffix}" => owner }


  readers_flatten = flatten([for db in var.databases :
    [for read_group in db.read_groups : {
      db : db
      read_group : read_group
  }]])

  readers_map = { for reader in local.readers_flatten : "${reader.read_group}_${reader.db.suffix}" => reader }

}

data "azuread_group" "read" {
  for_each         = local.readers_map
  display_name     = each.value.read_group
  security_enabled = true
}

data "azuread_group" "writer" {
  for_each         = local.owners_map
  display_name     = each.value.user_group
  security_enabled = true
}

resource "sqlsso_mssql_server_aad_account" "read" {

  for_each = local.readers_map

  sql_server_dns = azurerm_mssql_server.primary.fully_qualified_domain_name
  database       = local.databases_names_map[each.value.db.suffix]
  account_name   = data.azuread_group.read[each.key].display_name
  object_id      = data.azuread_group.read[each.key].object_id
  account_type   = "group"
  role           = "reader"

  depends_on = [
    azurerm_mssql_database.self,
    azurerm_mssql_firewall_rule.primary_rules,
  ]
}

resource "sqlsso_mssql_server_aad_account" "user" {

  for_each = local.owners_map

  sql_server_dns = azurerm_mssql_server.primary.fully_qualified_domain_name
  database       = local.databases_names_map[each.value.db.suffix]
  account_name   = data.azuread_group.writer[each.key].display_name
  object_id      = data.azuread_group.writer[each.key].object_id
  account_type   = "group"
  role           = "owner"

  depends_on = [
    azurerm_mssql_database.self,
    azurerm_mssql_firewall_rule.primary_rules,
  ]
}
