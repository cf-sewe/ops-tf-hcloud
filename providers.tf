# Hetzner Cloud
provider "hcloud" {
  token = var.hcloud_token
}

# Azure
provider "azurerm" {
  features {}
  environment                = "public"
  subscription_id            = var.azurerm_subscription_id
  tenant_id                  = var.azurerm_tenant_id
  client_id                  = var.azurerm_client_id
  client_secret              = var.azurerm_client_secret
  skip_provider_registration = true
}
