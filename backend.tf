terraform {
  required_version = ">= 0.12.6"
  
  backend "azurerm" {
    subscription_id      = "<subscription>"
    resource_group_name  = "wizDemoResourceGroup"
    storage_account_name = "wizpipelinestorage"
    container_name       = "terraformstate"
    key                  = "root.terraform.tfstate"
  }
}