***Autogenerated file - do not edit***

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >= 1.2.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.62.0 |
| <a name="requirement_sqlsso"></a> [sqlsso](#requirement\_sqlsso) | ~> 1.0 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group"></a> [admin\_group](#input\_admin\_group) | n/a | `string` | n/a | yes |
| <a name="input_caf_prefixes_dr"></a> [caf\_prefixes\_dr](#input\_caf\_prefixes\_dr) | Disaster recovery naming prefixes | `list(string)` | n/a | yes |
| <a name="input_caf_prefixes_main"></a> [caf\_prefixes\_main](#input\_caf\_prefixes\_main) | Principal naming prefixes | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name. | `string` | n/a | yes |
| <a name="input_tags_dr"></a> [tags\_dr](#input\_tags\_dr) | Tags for DR server | `map(string)` | n/a | yes |
| <a name="input_tags_main"></a> [tags\_main](#input\_tags\_main) | Tags for main server | `map(string)` | n/a | yes |
| <a name="input_custom_location"></a> [custom\_location](#input\_custom\_location) | n/a | `string` | `""` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | List of databases and user groups with access to them. | <pre>list(object({<br>    suffix                      = string<br>    database_description        = string<br>    collation                   = string<br>    sku_name                    = string<br>    min_capacity                = number<br>    zone_redundant              = bool<br>    auto_pause_delay_in_minutes = number<br>    storage_account_type        = string<br><br>    custom_tags = map(string)<br><br>    short_term_retention_policy = object({<br>      retention_days           = number<br>      backup_interval_in_hours = number<br>    })<br><br>    long_term_retention_policy = object({<br>      weekly_retention  = string<br>      monthly_retention = string<br>      yearly_retention  = string<br>      week_of_year      = string<br>    })<br><br>    user_groups = list(string)<br>    read_groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_instance_index"></a> [instance\_index](#input\_instance\_index) | Instance number | `number` | `1` | no |
| <a name="input_server_custom_name"></a> [server\_custom\_name](#input\_server\_custom\_name) | n/a | `string` | `""` | no |
| <a name="input_server_custom_tags"></a> [server\_custom\_tags](#input\_server\_custom\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_server_description"></a> [server\_description](#input\_server\_description) | SQL Server description. | `string` | `""` | no |
| <a name="input_sql_failover_group_policy"></a> [sql\_failover\_group\_policy](#input\_sql\_failover\_group\_policy) | Microsoft Azure SQL Failover Group policy. If not defined, no Failover Group will be created.<br><br>  location - SQL Server DR Location<br>  mode - specifies the failover mode : 'Manual' or 'Automatic'<br>  grace\_minutes - specifies the grace time in minutes before failover happened on 'Automatic' mode (should be 0 on 'Manual') | `object({ location = string, mode = string, grace_minutes = number })` | `null` | no |
| <a name="input_sql_server_firewall_rules"></a> [sql\_server\_firewall\_rules](#input\_sql\_server\_firewall\_rules) | Firewall rules to apply on SQL Server | `map(object({ name = string, start = string, end = string }))` | `{}` | no |
| <a name="input_sql_server_virtual_network_rules_dr"></a> [sql\_server\_virtual\_network\_rules\_dr](#input\_sql\_server\_virtual\_network\_rules\_dr) | Virtual network rules to apply on SQL DR Server | `list(string)` | `[]` | no |
| <a name="input_sql_server_virtual_network_rules_main"></a> [sql\_server\_virtual\_network\_rules\_main](#input\_sql\_server\_virtual\_network\_rules\_main) | Virtual network rules to apply on SQL Main Server | `list(string)` | `[]` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_names"></a> [database\_names](#output\_database\_names) | n/a |
| <a name="output_primary_server_fqdn"></a> [primary\_server\_fqdn](#output\_primary\_server\_fqdn) | n/a |
| <a name="output_primary_server_id"></a> [primary\_server\_id](#output\_primary\_server\_id) | n/a |
| <a name="output_primary_server_name"></a> [primary\_server\_name](#output\_primary\_server\_name) | n/a |
| <a name="output_secondary_server_fqdn"></a> [secondary\_server\_fqdn](#output\_secondary\_server\_fqdn) | n/a |
| <a name="output_secondary_server_id"></a> [secondary\_server\_id](#output\_secondary\_server\_id) | n/a |
| <a name="output_secondary_server_name"></a> [secondary\_server\_name](#output\_secondary\_server\_name) | n/a |

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >= 1.2.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.62.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |
| <a name="requirement_sqlsso"></a> [sqlsso](#requirement\_sqlsso) | 1.0.2 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group"></a> [admin\_group](#input\_admin\_group) | The name of the Azure AD group that will be the SQL Server admin. | `string` | n/a | yes |
| <a name="input_caf_prefixes_dr"></a> [caf\_prefixes\_dr](#input\_caf\_prefixes\_dr) | Disaster recovery naming prefixes. | `list(string)` | n/a | yes |
| <a name="input_caf_prefixes_main"></a> [caf\_prefixes\_main](#input\_caf\_prefixes\_main) | Principal naming prefixes. | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name. | `string` | n/a | yes |
| <a name="input_tags_dr"></a> [tags\_dr](#input\_tags\_dr) | Tags for DR server. | `map(string)` | n/a | yes |
| <a name="input_tags_main"></a> [tags\_main](#input\_tags\_main) | Tags for main server. | `map(string)` | n/a | yes |
| <a name="input_custom_location"></a> [custom\_location](#input\_custom\_location) | (Optional) Custom location for the SQL Server. | `string` | `""` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | (Optional) List of databases and user groups with access to them. | <pre>list(object({<br>    license_type                = optional(string, "BasePrice")<br>    suffix                      = string<br>    database_description        = string<br>    collation                   = optional(string, "SQL_Latin1_General_CP1_CI_AS")<br>    sku_name                    = string # Retrieve the available sku names with az sql db list-editions -l WestEurope -o table<br>    min_capacity                = optional(number)<br>    max_size_gb                 = optional(number)<br>    zone_redundant              = optional(bool, false)<br>    auto_pause_delay_in_minutes = optional(number)<br>    storage_account_type        = optional(string, "Geo")<br><br>    custom_tags = map(string)<br><br>    short_term_retention_policy = optional(object({<br>      retention_days           = optional(number, 1)<br>      backup_interval_in_hours = optional(number, 24)<br>    }))<br><br>    long_term_retention_policy = optional(object({<br>      weekly_retention  = string<br>      monthly_retention = string<br>      yearly_retention  = string<br>      week_of_year      = string<br>    }))<br><br>    user_groups = list(string)<br>    read_groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_dns_zone_group_name_use_caf"></a> [dns\_zone\_group\_name\_use\_caf](#input\_dns\_zone\_group\_name\_use\_caf) | (Optional) Use azurecaf\_name for Private DNS Zone Group name. | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | (Optional) The identity ids for the SQL Server. | `list(string)` | `null` | no |
| <a name="input_identity_project_tags"></a> [identity\_project\_tags](#input\_identity\_project\_tags) | (Optional) The required tags for the user assigned identity. | `map(string)` | `{}` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional) The identity type for the SQL Server. | `string` | `null` | no |
| <a name="input_identity_use_project_msi"></a> [identity\_use\_project\_msi](#input\_identity\_use\_project\_msi) | (Optional) Whether to use the project identity or not. | `bool` | `false` | no |
| <a name="input_instance_index"></a> [instance\_index](#input\_instance\_index) | (Optional) Instance number. | `number` | `1` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | (Optional) The private DNS zone for the Private Endpoints (privatelink.database.windows.net). | `list(string)` | `[]` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | (Optional) Should the server be accessible via Private Endpoint. | `bool` | `false` | no |
| <a name="input_private_endpoint_subnet_fog_id"></a> [private\_endpoint\_subnet\_fog\_id](#input\_private\_endpoint\_subnet\_fog\_id) | (Optional) The Private Endpoint subnet ID for failover group. | `string` | `null` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | (Optional) The Private Endpoint subnet ID. | `string` | `null` | no |
| <a name="input_server_custom_name"></a> [server\_custom\_name](#input\_server\_custom\_name) | (Optional) Custom name for the SQL Server. | `string` | `""` | no |
| <a name="input_server_custom_tags"></a> [server\_custom\_tags](#input\_server\_custom\_tags) | (Optional) Custom tags for the SQL Server. | `map(string)` | `{}` | no |
| <a name="input_server_description"></a> [server\_description](#input\_server\_description) | (Optional) SQL Server description. | `string` | `""` | no |
| <a name="input_sql_failover_group_policy"></a> [sql\_failover\_group\_policy](#input\_sql\_failover\_group\_policy) | (Optional) Microsoft Azure SQL Failover Group policy. If not defined, no Failover Group will be created.<br><br>  location - SQL Server DR Location<br>  mode - specifies the failover mode : 'Manual' or 'Automatic'<br>  grace\_minutes - specifies the grace time in minutes before failover happened on 'Automatic' mode (should be 0 on 'Manual') | `object({ location = string, mode = string, grace_minutes = number })` | `null` | no |
| <a name="input_sql_server_firewall_rules"></a> [sql\_server\_firewall\_rules](#input\_sql\_server\_firewall\_rules) | (Optional) Firewall rules to apply on SQL Server. | `map(object({ name = string, start = string, end = string }))` | `{}` | no |
| <a name="input_sql_server_virtual_network_rules_dr"></a> [sql\_server\_virtual\_network\_rules\_dr](#input\_sql\_server\_virtual\_network\_rules\_dr) | (Optional) Virtual network rules to apply on SQL DR Server. | `list(string)` | `[]` | no |
| <a name="input_sql_server_virtual_network_rules_main"></a> [sql\_server\_virtual\_network\_rules\_main](#input\_sql\_server\_virtual\_network\_rules\_main) | (Optional) Virtual network rules to apply on SQL Main Server. | `list(string)` | `[]` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_names"></a> [database\_names](#output\_database\_names) | A map where the key is the database suffix and the value is the database name. |
| <a name="output_databases_configuration"></a> [databases\_configuration](#output\_databases\_configuration) | A map where the key is the database suffix and the value is the database configuration and additional computed values. |
| <a name="output_primary_server_fqdn"></a> [primary\_server\_fqdn](#output\_primary\_server\_fqdn) | The FQDN of the primary SQL Server. |
| <a name="output_primary_server_id"></a> [primary\_server\_id](#output\_primary\_server\_id) | The ID of the primary SQL Server. |
| <a name="output_primary_server_name"></a> [primary\_server\_name](#output\_primary\_server\_name) | The name of the primary SQL Server. |
| <a name="output_secondary_server_fqdn"></a> [secondary\_server\_fqdn](#output\_secondary\_server\_fqdn) | The FQDN of the secondary SQL Server. |
| <a name="output_secondary_server_id"></a> [secondary\_server\_id](#output\_secondary\_server\_id) | The ID of the secondary SQL Server. |
| <a name="output_secondary_server_name"></a> [secondary\_server\_name](#output\_secondary\_server\_name) | The name of the secondary SQL Server. |
<!-- END_TF_DOCS -->