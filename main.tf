# new RG for the backup
resource "azurerm_resource_group" "aks_backup" {
  name     = var.backup_resource_group_name
  location = var.main_rg_location

  tags = var.tags
}

# private endpoint for network access
resource "azurerm_private_endpoint" "backup_sa_pe" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "pe-${azurerm_storage_account.aks_backup.name}"
  location            = azurerm_resource_group.aks_backup.location
  resource_group_name = azurerm_resource_group.aks_backup.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "pe-${azurerm_storage_account.aks_backup.name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.aks_backup.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = var.private_endpoint_dns_zone_name
    private_dns_zone_ids = var.private_endpoint_dns_zone_ids
  }
}

# provide storage
resource "azurerm_storage_account" "aks_backup" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.aks_backup.name
  location            = azurerm_resource_group.aks_backup.location

  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Deny"

    ip_rules = var.network_ip_access_list

    private_link_access {
      endpoint_resource_id = var.private_link_resource_id
      endpoint_tenant_id   = var.private_link_tenant_id
    }

    virtual_network_subnet_ids = var.virtual_network_subnet_ids

    # Allow Trusted Microsoft Services to bypass rules (Trivy AVD-AZU-0010)
    bypass = ["Metrics", "AzureServices"]
  }

  tags = merge(var.tags, {})
}

# actual storage container
resource "azurerm_storage_container" "velero" {
  name                  = "velero"
  storage_account_name  = azurerm_storage_account.aks_backup.name
  container_access_type = "private"
}

# create identity for access with general permission
resource "azurerm_user_assigned_identity" "backup_identity" {
  name                = var.backup_identity_name
  resource_group_name = azurerm_resource_group.aks_backup.name
  location            = azurerm_resource_group.aks_backup.location
}

resource "azurerm_role_assignment" "aks_noe_backup_identity" {
  scope                = azurerm_user_assigned_identity.backup_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.kubelet_identity_object_id
}

# Workload Identity: Use velero's k8s service account - yes, the name is hardcoded here....
resource "azurerm_federated_identity_credential" "backup_credential" {
  name                = "backup-${var.name_affix}"
  resource_group_name = azurerm_resource_group.aks_backup.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.backup_identity.id
  subject             = "system:serviceaccount:velero:velero-server" # default in Velero helm chart!!
}

# Allow backup identity to access Backup Storage Account for Velero
resource "azurerm_role_assignment" "backup_id_sa_data_contributor" {
  scope                = azurerm_storage_account.aks_backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.backup_identity.principal_id
}

# Additional identity with write access to blob
resource "azurerm_role_assignment" "additional_sa_data_contributor" {
  count                = var.additional_storage_contributor_role_principal == "" ? 0 : 1
  scope                = azurerm_storage_account.aks_backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.additional_storage_contributor_role_principal
}

resource "azurerm_role_assignment" "backup_id_sa_contributor" {
  scope                = azurerm_storage_account.aks_backup.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.backup_identity.principal_id
}

resource "azurerm_role_assignment" "backup_id_contributor" {
  scope                = azurerm_storage_account.aks_backup.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.backup_identity.principal_id
}
resource "azurerm_role_assignment" "backup_velero" {
  scope              = azurerm_storage_account.aks_backup.id
  role_definition_id = azurerm_role_definition.velero.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.backup_identity.principal_id
}

resource "azurerm_role_assignment" "backup_velero_nodes_rg" {
  scope              = var.node_resource_group_id
  role_definition_id = azurerm_role_definition.velero.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.backup_identity.principal_id
}

# Custom Role for access to backup and PVs in use
resource "azurerm_role_definition" "velero" {
  name        = "Velero-${var.name_affix}"
  scope       = azurerm_storage_account.aks_backup.id
  description = "This is a custom role for Velero"

  permissions {
    actions = [
      "Microsoft.Compute/disks/read",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/endGetAccess/action",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.Compute/snapshots/read",
      "Microsoft.Compute/snapshots/write",
      "Microsoft.Compute/snapshots/delete",
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.Storage/storageAccounts/regeneratekey/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action"
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
    ]
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}",
    "/subscriptions/${var.subscription_id}/resourceGroups/${var.node_resource_group}",
    "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.aks_backup.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.aks_backup.name}"
  ]

}

