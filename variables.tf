variable "hcloud_token" {
  sensitive   = true
  description = "Hetzner Cloud API Token"
}

variable "hcloud_environment" {
  description = "Name of the Hetzner Cloud Project (environment). Must be unique within Hetzner Cloud."
}

variable "hcloud_datacenter" {
  default     = "fsn1"
  description = "Hetzner Cloud location. You can list locations with 'hcloud location list'"
}

variable "hcloud_datacenter_alt" {
  default     = "nbg1"
  description = "Alternative hcloud location for active-passive second site."
}

variable "cplace_node_count" {
  default     = "1"
  description = "Specifies the number of cplace Nodes for HA"
}

variable "cplace_enable_active_passive" {
  default     = false
  description = "Whether to enable active-passive mode"
}

variable "cplace_server_type" {
  default     = "cpx21"
  description = "Defines the cplace server type."
}

variable "ldaps_ipv4_address" {
  default     = "51.144.58.61/32"
  description = "IP address of the LDAP server used for central authentication (ldaps.collaboration-factory.de)."
}

# Azure credentials for ADDS firewall
# see https://docs.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure
# /subscriptions/97c563b8-5a8c-49ef-a21a-7c0b75bac09a/resourceGroups/rg-azuread/providers/Microsoft.Network/networkSecurityGroups/aadds-nsg
variable "azurerm_resource_group_name" {
  default     = "rg-azuread"
  description = "Azure resource group name"
}
variable "azurerm_network_security_group_name" {
  default     = "aadds-nsg"
  description = "Azure network security group name"
}
variable "azurerm_network_security_rule_priority" {
  default     = 500
  description = "Defines the priority of the network security rule. Must be unique."
}
variable "azurerm_subscription_id" {
  default     = "97c563b8-5a8c-49ef-a21a-7c0b75bac09a"
  description = "Azure Subscription Id"
}
variable "azurerm_tenant_id" {
  default     = "e600793b-26fc-4408-b046-8ad41425162d"
  description = "Azure Tenant Id (tenant)"
}
variable "azurerm_client_id" {
  default     = "7a656829-e7f0-4abc-bd38-c490fdd3c94f"
  description = "Azure Client Id (appId)"
}
variable "azurerm_client_secret" {
  sensitive   = true
  description = "Azure Client Secret (password)"
}
