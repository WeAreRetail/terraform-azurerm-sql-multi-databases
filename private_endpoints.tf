resource "azurecaf_name" "private_dns_zone_group" {

  count         = var.private_endpoint && var.dns_zone_group_name_use_caf ? 1 : 0
  name          = "sqlServer"
  resource_type = "azurerm_private_dns_zone_group"
  prefixes      = var.caf_prefixes_main
  suffixes      = []
  use_slug      = true
  clean_input   = true
  separator     = ""
  random_length = 3
}

module "private_endpoint" {
  source = "WeAreRetail/private-endpoint/azurerm"

  count = var.private_endpoint ? 1 : 0

  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  resource_id         = azurerm_mssql_server.primary.id
  caf_prefixes        = var.caf_prefixes_main

  private_dns_zone_group = [{
    name = var.dns_zone_group_name_use_caf ? azurecaf_name.private_dns_zone_group[0].result : "default",
    ids  = var.private_dns_zone_ids
  }]

  subresource_names = ["sqlServer"]
}

resource "azurecaf_name" "private_dns_zone_group_fog" {

  count         = var.private_endpoint && local.with_failover_group && var.dns_zone_group_name_use_caf ? 1 : 0
  name          = "sqlServerfog"
  resource_type = "azurerm_private_dns_zone_group"
  prefixes      = var.caf_prefixes_dr
  suffixes      = []
  use_slug      = true
  clean_input   = true
  separator     = ""
  random_length = 3
}


module "private_endpoint_fog" {
  source = "WeAreRetail/private-endpoint/azurerm"

  count = var.private_endpoint && local.with_failover_group ? 1 : 0

  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_fog_id
  resource_id         = azurerm_mssql_server.secondary[0].id
  caf_prefixes        = var.caf_prefixes_dr

  private_dns_zone_group = [{
    name = var.dns_zone_group_name_use_caf ? azurecaf_name.private_dns_zone_group_fog[0].result : "default",
    ids  = var.private_dns_zone_ids
  }]

  subresource_names = ["sqlServer"]
}
