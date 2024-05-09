data "azurerm_resources" "user_managed_identity" {
  count         = var.identity_use_project_msi ? 1 : 0
  type          = "Microsoft.ManagedIdentity/userAssignedIdentities"
  required_tags = var.identity_project_tags
}

locals {
  userassignedidentity_backbone_group_name = var.identity_use_project_msi ? one(data.azurerm_resources.user_managed_identity[0].resources).resource_group_name : "not_enabled"
  userassignedidentity_name                = var.identity_use_project_msi ? one(data.azurerm_resources.user_managed_identity[0].resources).name : "not_enabled"
}

data "azurerm_user_assigned_identity" "user_identity" {
  count               = var.identity_use_project_msi ? 1 : 0
  name                = local.userassignedidentity_name
  resource_group_name = local.userassignedidentity_backbone_group_name
}
