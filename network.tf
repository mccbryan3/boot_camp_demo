resource "azurerm_virtual_network" "jenkins_demo" {
  name                = "demo-network"
  location            = data.azurerm_resource_group.jenkins_demo.location
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name
  address_space       = ["10.150.0.0/16"]

  subnet {
    name           = var.subnet_name
    address_prefix = "10.150.1.0/24"
  }

  tags = var.tags
}

data "azurerm_subnet" "jenkins_demo" {
  name = var.subnet_name
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name
  virtual_network_name = azurerm_virtual_network.jenkins_demo.name
  depends_on = [
    azurerm_virtual_network.jenkins_demo
  ]
}

