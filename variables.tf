variable "node_resource_group" {
  type        = string
  description = "The name of the resource group the AKS nodes are running in"
}
variable "tags" {
  type        = map(string)
  description = "The tags to be applied to all the resources"
}
variable "name_affix" {
  type        = string
  description = "The name to affix to resources for uniqueness"
}
variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID to use"
}
variable "network_ip_access_list" {
  type        = list(string)
  description = "The list of IP addresses to allow direct access to the storage"
}
variable "main_rg_name" {
  type        = string
  description = "Name of the main RG for resources"
}
variable "oidc_issuer_url" {
  type        = string
  description = "The URL of the AKS cluster's OIDC issuer"
}
variable "kubelet_identity_object_id" {
  type        = string
  description = "Object ID of the cluster's kubelet identity"
}
variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "List of IDs of the subnets that should be connected to the storage"
}
variable "network_ip_rules" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks to access the storage."
}
variable "create_private_endpoint" {
  type        = bool
  description = "Whether to set up a privte end"
  default     = true
}
variable "private_endpoint_subnet_id" {
  type        = string
  description = "The ID of the subnet for the private endpoint"
}
variable "private_endpoint_dns_zone_name" {
  type        = string
  description = "Name of the private DNS zone"
  default     = "int-zone"
}
variable "private_endpoint_dns_zone_ids" {
  type        = list(string)
  description = "List of IDs"
}
variable "private_link_resource_id" {
  type        = string
  description = "The resource ID of the private link"
}
variable "private_link_tenant_id" {
  type        = string
  description = "The tenant ID of the private link"
}
variable "storage_contributor_role_principal" {
  type        = string
  description = "Additional role to be stroage contributor"
}
variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to create"
}
variable "backup_resource_group_name" {
  type        = string
  description = "Name of the RG for the backup"
}
variable "backup_identity_name" {
  type        = string
  description = "Name of the identity for backup"
}
