output "velero_client_id" {
  value = azurerm_user_assigned_identity.backup_identity.client_id
}

