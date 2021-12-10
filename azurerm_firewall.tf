##
# Manage Azure Firewall
# required to allow a connection from our servers to the ADDS endpoint (ldaps.collaboration-factory.de)
# each environment will get its own rule

data "azurerm_resource_group" "azuread" {
  name = var.azurerm_resource_group_name
}

data "azurerm_network_security_group" "adds" {
  name                = var.azurerm_network_security_group_name
  resource_group_name = data.azurerm_resource_group.azuread.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "hcloud-ldaps-${var.hcloud_environment}"
  description                 = "Allow LDAPS connection from Hetzner Cloud servers (${var.hcloud_environment})"
  priority                    = var.azurerm_network_security_rule_priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "636"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.azuread.name
  network_security_group_name = data.azurerm_network_security_group.adds.name
}
