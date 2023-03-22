# YOUR PROVIDER(S)
terraform {
  required_version = ">=1.00"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
      subscription_id="cdc883e8-695a-42c8-a91d-d37379e70e8b"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
