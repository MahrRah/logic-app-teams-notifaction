
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use an appropriate version
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0" # Adjust to the latest appropriate version
    }
  }
}

data "azurerm_subscription" "current" {
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}

resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "example-logic-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  workflow_parameters = {
    "$connections" = jsonencode(
      {
        defaultValue = {}
        type         = "Object"
      }
    )
  }
}

resource "azurerm_logic_app_trigger_http_request" "request_trigger" {
  name         = "alert trigger"
  logic_app_id = azurerm_logic_app_workflow.logic_app.id

  schema = file("${path.module}/files/alert_schema.json")
}


resource "azurerm_logic_app_action_http" "whoahhh" {
  name         = "teams webhook"
  logic_app_id = azurerm_logic_app_workflow.logic_app.id
  method       = "POST"
  uri          = var.webhook_url
  headers = {
    "Content-Type" = "application/json"
  }

  body = file("${path.module}/files/action_post_to_teams.json")

}

output "url" {
  value = azurerm_logic_app_trigger_http_request.request_trigger.callback_url
}
