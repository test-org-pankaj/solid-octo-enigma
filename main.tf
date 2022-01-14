#module "az-rg" {
#  source  = "app.terraform.io/accurics-sa/az-rg/test"
#  version = "1.0.0"
#}


# Configure the Azure provider
terraform {
  required_version = ">= 0.12.0"
}

provider "azurerm" {
  features {}
}

#Create a Resource Group
resource "azurerm_resource_group" "pa_demo_rg" {
  name     = "pa_demo_rg"
  location = "westus2"
  tags = {
    Owner            = "paul.anderson@accurics.com"
    Purpose          = "Product demonstrations"
    Created_Date     = timestamp()
    Department       = "Solutions Architecture"
    Estimated_Expiry = timeadd(timestamp(), "720h")
  }
}

#Fix for unlocked Resource Group
#resource "azurerm_management_lock" "resource-group-level" {
#  name = "pa_demo_rg_lock"
#  scope = azurerm_resource_group.pa_demo_rg.id
#  lock_level   = "ReadOnly"
#  lock_level = "CanNotDelete"
#  notes = "This Resource Group has a Management Lock"
#}

#Create SSH Security Group
resource "azurerm_network_security_group" "pa_demo_sg_ssh" {
  name                = "pa_demo_sg_ssh"
  location            = azurerm_resource_group.pa_demo_rg.location
  resource_group_name = azurerm_resource_group.pa_demo_rg.name
  tags = {
    Owner            = "paul.anderson@accurics.com"
    Purpose          = "Product demonstrations"
    Created_Date     = timestamp()
    Department       = "Marketing"
    Estimated_Expiry = timeadd(timestamp(), "720h")
  }
}

#Alternatvely restrictive and permissive SSH rule
resource "azurerm_network_security_rule" "ssh_security_rule" {
  name                   = "ssh_security_rule"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "22"
  # source_address_prefix  = "0.0.0.0/0"
  source_address_prefix       = "10.0.0.0/30"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pa_demo_rg.name
  network_security_group_name = azurerm_network_security_group.pa_demo_sg_ssh.name
}

#Create port 8000 Security Group
resource "azurerm_network_security_group" "pa_demo_sg_eightk" {
  name                = "pa_demo_sg_eightk"
  location            = azurerm_resource_group.pa_demo_rg.location
  resource_group_name = azurerm_resource_group.pa_demo_rg.name
  tags = {
    Owner            = "paul.anderson@accurics.com"
    Purpose          = "Product demonstrations"
    Created_Date     = timestamp()
    Department       = "Marketing"
    Estimated_Expiry = timeadd(timestamp(), "720h")
  }
}

#Alternatvely restrictive and permissive port 8000 rule
resource "azurerm_network_security_rule" "eightk_security_rule" {
  name                   = "eightk_security_rule"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "8000"
  # source_address_prefix  = "0.0.0.0/0"
  source_address_prefix       = "10.0.0.0/30"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pa_demo_rg.name
  network_security_group_name = azurerm_network_security_group.pa_demo_sg_eightk.name
}
