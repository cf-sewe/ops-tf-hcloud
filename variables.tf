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

variable "hcloud_servertype_docker" {
  default     = "cpx21"
  description = "hcloud server type for Docker"
}

variable "ldaps_ipv4_address" {
  default     = "51.144.58.61/32"
  description = "IP address of the LDAP server used for central authentication (ldaps.collaboration-factory.de)"
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
  description = "Azure Client Id (appId)"
}
variable "azurerm_client_secret" {
  sensitive   = true
  description = "Azure Client Secret (password)"
}

# http://vcloud-lab.com/entries/microsoft-azure/terraform-for-each-loop-on-map-example
variable "cplace_servers" {
  description = "hcloud servers for cplace, database, elasticsearch"
  type = map(object({
    name        = string
    ip          = string
    location    = string
    server_type = string
  }))
  default = {
    "1" = {
      name        = "cplace"
      ip          = "10.77.1.10"
      location    = "fsn1"
      server_type = "cpx21"
    }
    "2" = {
      name        = "db"
      ip          = "10.77.1.20"
      location    = "fsn1"
      server_type = "cpx21"
    }
    "3" = {
      name        = "es"
      ip          = "10.77.1.30"
      location    = "fsn1"
      server_type = "cpx21"
    }
  }
}