variable "admin_group" {
  type        = string
  description = "The name of the Azure AD group that will be the SQL Server admin."
}

variable "caf_prefixes_dr" {
  type        = list(string)
  description = "Disaster recovery naming prefixes."
}

variable "caf_prefixes_main" {
  type        = list(string)
  description = "Principal naming prefixes."
}

variable "custom_location" {
  type        = string
  description = "(Optional) Custom location for the SQL Server."
  default     = ""
}

variable "databases" {
  type = list(object({
    license_type                = optional(string, "BasePrice")
    suffix                      = string
    database_description        = string
    collation                   = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    sku_name                    = string # Retrieve the available sku names with az sql db list-editions -l WestEurope -o table
    min_capacity                = optional(number)
    max_size_gb                 = optional(number)
    zone_redundant              = optional(bool, false)
    auto_pause_delay_in_minutes = optional(number)
    storage_account_type        = optional(string, "Geo")

    custom_tags = map(string)

    short_term_retention_policy = optional(object({
      retention_days           = optional(number, 1)
      backup_interval_in_hours = optional(number, 24)
    }))

    long_term_retention_policy = optional(object({
      weekly_retention  = string
      monthly_retention = string
      yearly_retention  = string
      week_of_year      = string
    }))

    user_groups = list(string)
    read_groups = list(string)
  }))
  description = "(Optional) List of databases and user groups with access to them."
  default     = []
}

variable "identity_ids" {
  type        = list(string)
  description = "(Optional) The identity ids for the SQL Server."
  default     = null
}

variable "identity_project_tags" {
  type        = map(string)
  description = "(Optional) The required tags for the user assigned identity."
  default     = {}
}

variable "identity_type" {
  type        = string
  description = "(Optional) The identity type for the SQL Server."
  default     = null

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned, UserAssigned", "SystemAssigned", "UserAssigned"], coalesce(var.identity_type, "empty"))
    error_message = "The identity type is invalid. It must be 'null', 'SystemAssigned, UserAssigned', 'SystemAssigned', 'UserAssigned'."
  }
}

variable "identity_use_project_msi" {
  type        = bool
  description = "(Optional) Whether to use the project identity or not."
  default     = false
}

variable "instance_index" {
  type        = number
  description = "(Optional) Instance number."
  default     = 1
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "(Optional) The private DNS zone for the Private Endpoints (privatelink.database.windows.net)."
  default     = []
}

variable "private_endpoint_subnet_fog_id" {
  type        = string
  description = "(Optional) The Private Endpoint subnet ID for failover group."
  default     = null
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "(Optional) The Private Endpoint subnet ID."
  default     = null
}

variable "private_endpoint" {
  type        = bool
  description = "(Optional) Should the server be accessible via Private Endpoint."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "server_custom_name" {
  type        = string
  description = "(Optional) Custom name for the SQL Server."
  default     = ""
}

variable "server_custom_tags" {
  type        = map(string)
  description = "(Optional) Custom tags for the SQL Server."
  default     = {}
}

variable "server_description" {
  type        = string
  default     = ""
  description = "(Optional) SQL Server description."
}

variable "sql_failover_group_policy" {

  type        = object({ location = string, mode = string, grace_minutes = number })
  description = <<EOT
  (Optional) Microsoft Azure SQL Failover Group policy. If not defined, no Failover Group will be created.

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

variable "dns_zone_group_name_use_caf" {
  type        = bool
  description = "(Optional) Use azurecaf_name for Private DNS Zone Group name."
  default     = false
}

variable "sql_server_firewall_rules" {
  type        = map(object({ name = string, start = string, end = string }))
  description = "(Optional) Firewall rules to apply on SQL Server."
  default     = {}
}

variable "sql_server_virtual_network_rules_dr" {
  type        = list(string)
  description = "(Optional) Virtual network rules to apply on SQL DR Server."
  default     = []
}

variable "sql_server_virtual_network_rules_main" {
  type        = list(string)
  description = "(Optional) Virtual network rules to apply on SQL Main Server."
  default     = []
}

variable "tags_dr" {
  type        = map(string)
  description = "Tags for DR server."
}


variable "tags_main" {
  type        = map(string)
  description = "Tags for main server."
}
