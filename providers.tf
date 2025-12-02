# Determine the current Terraform workspace
terraform {
  required_version = ">= 1.6"
}

locals {
  current_env = terraform.workspace != "default" ? terraform.workspace : "dev"
  tfvars_file = "envs/${local.current_env}/terraform.tfvars"
}

# Load variables automatically from the workspace-specific tfvars file
terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
