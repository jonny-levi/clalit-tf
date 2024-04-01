terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

resource "azurerm_resource_group" "clalit-rg" {
  name     = "example-resources"
  location = "West Europe"
}



# Create a virtual network within the resource group
resource "azurerm_virtual_network" "clalit-vn" {
  name                = "clalit-network"
  resource_group_name = azurerm_resource_group.clalit-rg.name
  location            = azurerm_resource_group.clalit-rg.location
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "service" {
  name                                          = "service"
  resource_group_name                           = azurerm_resource_group.clalit-rg.name
  virtual_network_name                          = azurerm_virtual_network.clalit-vn.name
  address_prefixes                              = ["10.0.1.0/24"]
  enforce_private_link_service_network_policies = true
}

resource "azurerm_subnet" "endpoint" {
  name                 = "endpoint"
  resource_group_name  = azurerm_resource_group.clalit-rg.name
  virtual_network_name = azurerm_virtual_network.clalit-vn.name
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_storage_account" "example" {
  name                     = "clalitaccount"
  resource_group_name      = azurerm_resource_group.clalit-rg.name
  location                 = azurerm_resource_group.clalit-rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}
