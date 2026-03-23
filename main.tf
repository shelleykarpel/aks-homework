# 1. Setting up the Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 2.  Creating a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "aks-production-rg"
  location = "East US" 
}

# 3. Creating a Virtual Network and Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.240.0.0/16"]
}

# 4. Adding the AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-homework-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akshomework"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2s_v3" 
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  # RBAC enabled
  role_based_access_control_enabled = true

  # Network Policy Support
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure" 
    load_balancer_sku = "standard"
  }
}