terraform {
  required_version = ">= 0.12.6"
  
  backend "azurerm" {
    subscription_id      = "cdc883e8-695a-42c8-a91d-d37379e70e8b"
    resource_group_name  = "wizDemoResourceGroup"
    storage_account_name = "pipelinedavid1334"
    container_name       = "terraformstate"
    key                  = "root.terraform.tfstate"
  }
}
