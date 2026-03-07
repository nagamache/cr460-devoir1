terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "nagamache-cr460"
    workspaces {
      name = "cr460-devoir1"
    }
  }
}

provider "azurerm" {
  features {}
}