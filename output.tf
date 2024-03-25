output "primary_server_id" {
  description = "The ID of the primary SQL Server."
  value       = azurerm_mssql_server.primary.id
}

output "secondary_server_id" {
  description = "The ID of the secondary SQL Server."
  value       = local.with_failover_group ? azurerm_mssql_server.secondary[0].id : null
}

output "primary_server_name" {
  description = "The name of the primary SQL Server."
  value       = local.primary_server_name
}

output "secondary_server_name" {
  description = "The name of the secondary SQL Server."
  value       = local.with_failover_group ? azurecaf_name.secondary_server[0].result : null
}

output "primary_server_fqdn" {
  description = "The FQDN of the primary SQL Server."
  value       = local.with_failover_group ? replace(azurerm_mssql_server.primary.fully_qualified_domain_name, local.primary_server_name, azurecaf_name.self_fog.result) : azurerm_mssql_server.primary.fully_qualified_domain_name
}

output "secondary_server_fqdn" {
  description = "The FQDN of the secondary SQL Server."
  value       = local.with_failover_group ? replace(azurerm_mssql_server.primary.fully_qualified_domain_name, local.primary_server_name, "${azurecaf_name.self_fog.result}.secondary") : null
}

output "database_names" {
  description = "A map where the key is the database suffix and the value is the database name."
  value       = local.databases_names_map
}

output "databases_configuration" {
  description = "A map where the key is the database suffix and the value is the database configuration and additional computed values."
  value       = local.databases_configuration
}
