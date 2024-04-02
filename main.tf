terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
resource "azurerm_resource_group" "clalit-rg" {
  name     = "clalit-exam"
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

<<<<<<< HEAD
=======
resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  sku                 = "Standard"
  location            = azurerm_resource_group.clalit-rg.location
  resource_group_name = azurerm_resource_group.clalit-rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = "example-lb"
  sku                 = "Standard"
  location            = azurerm_resource_group.clalit-rg.location
  resource_group_name = azurerm_resource_group.clalit-rg.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.example.name
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_private_link_service" "clalit-prv-lnk-svc" {
  name                = "example-privatelink"
  location            = azurerm_resource_group.clalit-rg.location
  resource_group_name = azurerm_resource_group.clalit-rg.name

  nat_ip_configuration {
    name      = azurerm_public_ip.example.name
    primary   = true
    subnet_id = azurerm_subnet.service.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.example.frontend_ip_configuration[0].id,
  ]
}


resource "azurerm_private_endpoint" "example" {
  name                = "clalit-endpoint"
  location            = azurerm_resource_group.clalit-rg.location
  resource_group_name = azurerm_resource_group.clalit-rg.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = "clalit-privateserviceconnection"
    private_connection_resource_id = azurerm_private_link_service.example.id
    is_manual_connection           = false
  }
}

>>>>>>> 9a964bd (wip)
resource "azurerm_storage_account" "clalit-storage-account" {
  name                     = "clalitaccount"
  resource_group_name      = azurerm_resource_group.clalit-rg.name
  location                 = azurerm_resource_group.clalit-rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}


resource "azurerm_app_service_plan" "clalit-app-svc-plan" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.clalit-rg.location
  resource_group_name = azurerm_resource_group.clalit-rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.clalit-rg.location
  resource_group_name        = azurerm_resource_group.clalit-rg.name
  app_service_plan_id        = azurerm_app_service_plan.clalit-app-svc-plan.id
  storage_account_name       = azurerm_storage_account.clalit-storage-account.name
  storage_account_access_key = azurerm_storage_account.clalit-storage-account.primary_access_key
<<<<<<< HEAD
}
=======
}
>>>>>>> 9a964bd (wip)
