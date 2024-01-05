# tf-azure-velero
Terraform Module to manage velero resources for DataPlatforms' AKS clusters.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.39.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.backup_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_private_endpoint.backup_sa_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.aks_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.additional_sa_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_noe_backup_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.backup_id_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.backup_id_sa_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.backup_id_sa_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.backup_velero](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.backup_velero_nodes_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.velero](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_storage_account.aks_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.velero](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.backup_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_storage_contributor_role_principal"></a> [additional\_storage\_contributor\_role\_principal](#input\_additional\_storage\_contributor\_role\_principal) | Additional role principle to be storage contributor | `string` | `""` | no |
| <a name="input_backup_identity_name"></a> [backup\_identity\_name](#input\_backup\_identity\_name) | Name of the identity for backup | `string` | n/a | yes |
| <a name="input_backup_resource_group_name"></a> [backup\_resource\_group\_name](#input\_backup\_resource\_group\_name) | Name of the RG for the backup | `string` | n/a | yes |
| <a name="input_create_private_endpoint"></a> [create\_private\_endpoint](#input\_create\_private\_endpoint) | Whether to set up a privte end | `bool` | `true` | no |
| <a name="input_kubelet_identity_object_id"></a> [kubelet\_identity\_object\_id](#input\_kubelet\_identity\_object\_id) | Object ID of the cluster's kubelet identity | `string` | n/a | yes |
| <a name="input_main_rg_location"></a> [main\_rg\_location](#input\_main\_rg\_location) | Location of main backup RG | `string` | n/a | yes |
| <a name="input_main_rg_name"></a> [main\_rg\_name](#input\_main\_rg\_name) | Name of the main RG for resources | `string` | n/a | yes |
| <a name="input_name_affix"></a> [name\_affix](#input\_name\_affix) | The name to affix to resources for uniqueness | `string` | n/a | yes |
| <a name="input_network_ip_access_list"></a> [network\_ip\_access\_list](#input\_network\_ip\_access\_list) | The list of IP addresses to allow direct access to the storage | `list(string)` | n/a | yes |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | The name of the resource group the AKS nodes are running in | `string` | n/a | yes |
| <a name="input_node_resource_group_id"></a> [node\_resource\_group\_id](#input\_node\_resource\_group\_id) | The name of the resource group the AKS nodes are running in | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | The URL of the AKS cluster's OIDC issuer | `string` | n/a | yes |
| <a name="input_private_endpoint_dns_zone_ids"></a> [private\_endpoint\_dns\_zone\_ids](#input\_private\_endpoint\_dns\_zone\_ids) | List of IDs | `list(string)` | n/a | yes |
| <a name="input_private_endpoint_dns_zone_name"></a> [private\_endpoint\_dns\_zone\_name](#input\_private\_endpoint\_dns\_zone\_name) | Name of the private DNS zone | `string` | `"int-zone"` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | The ID of the subnet for the private endpoint | `string` | n/a | yes |
| <a name="input_private_link_resource_id"></a> [private\_link\_resource\_id](#input\_private\_link\_resource\_id) | The resource ID of the private link | `string` | n/a | yes |
| <a name="input_private_link_tenant_id"></a> [private\_link\_tenant\_id](#input\_private\_link\_tenant\_id) | The tenant ID of the private link | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account to create | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure Subscription ID to use | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be applied to all the resources | `map(string)` | n/a | yes |
| <a name="input_virtual_network_subnet_ids"></a> [virtual\_network\_subnet\_ids](#input\_virtual\_network\_subnet\_ids) | List of IDs of the subnets that should be connected to the storage | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_backup"></a> [azure\_backup](#output\_azure\_backup) | Values to be included in the metadata.json |
<!-- END_TF_DOCS -->
