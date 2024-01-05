output "azure_backup" {
  description = "Values to be included in the metadata.json"
  value = {
    client_id          = azurerm_user_assigned_identity.backup_identity.client_id
    nodes_rg           = var.node_resource_group
    resource_id        = azurerm_user_assigned_identity.backup_identity.id
    storage_account    = azurerm_storage_account.aks_backup.name
    storage_account_rg = azurerm_resource_group.aks_backup.name
    storage_region     = azurerm_resource_group.aks_backup.location
    subscription_id    = var.subscription_id
  }
}
