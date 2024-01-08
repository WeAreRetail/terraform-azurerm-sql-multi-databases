output "primary_server_id" {
  value = azurerm_mssql_server.primary.id
}

output "secondary_server_id" {
  value = local.with_failover_group ? azurerm_mssql_server.secondary[0].id : null
}

output "primary_server_name" {
  value = local.primary_server_name
}

output "secondary_server_name" {
  value = local.with_failover_group ? azurecaf_name.secondary_server[0].result : null
}

output "primary_server_fqdn" {
  value = local.with_failover_group ? replace(azurerm_mssql_server.primary.fully_qualified_domain_name, local.primary_server_name, azurecaf_name.self_fog.result) : azurerm_mssql_server.primary.fully_qualified_domain_name
}

output "secondary_server_fqdn" {
  value = local.with_failover_group ? replace(azurerm_mssql_server.primary.fully_qualified_domain_name, local.primary_server_name, "${azurecaf_name.self_fog.result}.secondary") : null
}

output "database_names" {
  value = local.databases_names_map
}
