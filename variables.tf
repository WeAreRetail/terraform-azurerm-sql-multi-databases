variable "caf_prefixes_main" {
  type        = list(string)
  description = "Principal naming prefixes"
}

variable "caf_prefixes_dr" {
  type        = list(string)
  description = "Disaster recovery naming prefixes"
}

variable "instance_index" {
  type        = number
  description = "Instance number"
  default     = 1
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "(Optional) The private DNS zone for the Private Endpoints (privatelink.database.windows.net)."
  default     = []
}

variable "private_endpoint" {
  type        = bool
  description = "(Optional) Should the server be accessible via Private Endpoint"
  default     = false
}

variable "private_endpoint_subnet_fog_id" {
  type        = string
  description = "(Optional) The Private Endpoint subnet ID for failover group"
  default     = null
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "(Optional) The Private Endpoint subnet ID"
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "server_custom_name" {
  type    = string
  default = ""
}

variable "server_custom_tags" {
  type    = map(string)
  default = {}
}

variable "server_description" {
  type        = string
  default     = ""
  description = "SQL Server description."
}

variable "tags_main" {
  type        = map(string)
  description = "Tags for main server"
}

variable "tags_dr" {
  type        = map(string)
  description = "Tags for DR server"
}


variable "custom_location" {
  type    = string
  default = ""
}

variable "admin_group" {
  type = string
}

variable "sql_server_firewall_rules" {
  type        = map(object({ name = string, start = string, end = string }))
  description = "Firewall rules to apply on SQL Server"
  default     = {}
}

variable "sql_server_virtual_network_rules_main" {
  type        = list(string)
  description = "Virtual network rules to apply on SQL Main Server"
  default     = []
}

variable "sql_server_virtual_network_rules_dr" {
  type        = list(string)
  description = "Virtual network rules to apply on SQL DR Server"
  default     = []
}

variable "sql_failover_group_policy" {

  type        = object({ location = string, mode = string, grace_minutes = number })
  description = <<EOT
  Microsoft Azure SQL Failover Group policy. If not defined, no Failover Group will be created.

  location - SQL Server DR Location
  mode - specifies the failover mode : 'Manual' or 'Automatic'
  grace_minutes - specifies the grace time in minutes before failover happened on 'Automatic' mode (should be 0 on 'Manual')

  EOT
  default     = null

  #validation {
  #  condition     = var.sql_failover_group_policy == null || (var.sql_failover_group_policy == null ? "" : var.sql_failover_group_policy.mode) == "Manual" || (var.sql_failover_group_policy == null ? 0 : var.sql_failover_group_policy.grace_minutes) >= 60
  #  error_message = "The SQL failover group policy is invalid. If 'mode' is 'Automatic', 'grace_minutes' must be defined and equal or greater than 60."
  #}
}



####
# Modularized Databases
####

variable "databases" {
  type = list(object({
    license_type                = optional(string, "BasePrice")
    suffix                      = string
    database_description        = string
    collation                   = string
    sku_name                    = string
    min_capacity                = number
    zone_redundant              = bool
    auto_pause_delay_in_minutes = number
    storage_account_type        = string

    custom_tags = map(string)

    short_term_retention_policy = object({
      retention_days           = number
      backup_interval_in_hours = number
    })

    long_term_retention_policy = object({
      weekly_retention  = string
      monthly_retention = string
      yearly_retention  = string
      week_of_year      = string
    })

    user_groups = list(string)
    read_groups = list(string)
  }))
  description = "List of databases and user groups with access to them."
  default     = []
}

variable "dns_zone_group_name_use_caf" {
  type        = bool
  description = "(optional) Use azurecaf_name for Private DNS Zone Group name"
  default     = false
}
