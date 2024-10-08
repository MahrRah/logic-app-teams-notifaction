
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

locals {
  email               = ""
  teams_connection_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/teams"
}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}

resource "azapi_resource" "teams_api_connection" {
  type                      = "Microsoft.Web/connections@2016-06-01"
  name                      = "teams-connection-${var.suffix}"
  location                  = azurerm_resource_group.rg.location
  parent_id                 = azurerm_resource_group.rg.id
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      displayName = local.email

      api = {
        name        = "teams"
        displayName = "Microsoft Teams"
        description = "Microsoft Teams enables you to get all your content, tools and conversations in the Team workspace with Microsoft 365."
        id          = local.teams_connection_id
        type        = "Microsoft.Web/locations/managedApis"
        iconUri     = "https://connectoricons-prod.azureedge.net/releases/v1.0.1705/1.0.1705.3833/teams/icon.png"
        brandColor  = "#4B53BC"
        category    = "Standard"
      }
    }
  })
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

  parameters = {
    "$connections" = jsonencode({
      "teams" : {
        "connectionId"   = azapi_resource.teams_api_connection.id
        "connectionName" = azapi_resource.teams_api_connection.name
        "id"             = local.teams_connection_id
      }
    })
  }
}

resource "azurerm_logic_app_trigger_http_request" "request_trigger" {
  name         = "alert trigger"
  logic_app_id = azurerm_logic_app_workflow.logic_app.id

  schema = file("${path.module}/files/alert_schema.json")
}

resource "azurerm_logic_app_action_custom" "action-post-to-teams" {
  name         = "teams message action"
  logic_app_id = azurerm_logic_app_workflow.logic_app.id
  body         = file("${path.module}/files/action_post_to_teams.json")
}

output "url" {
  value = azurerm_logic_app_trigger_http_request.request_trigger.callback_url
}
