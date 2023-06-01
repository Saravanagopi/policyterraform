provider "azurerm" {
  features {}
}

resource "azurerm_policy_definition" "policy" {
  name         = "policyrestrictrbacfalse"
  policy_type  = "Custom"
  mode         = "All"
  display_name = var.name
  description  = "This policy enables you to restrict the rbac false"
  metadata     = <<METADATA
    {
         "category": "${var.policy_definition_category}"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.KeyVault/vaults"
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.KeyVault/vaults/enableRbacAuthorization",
                "equals": "false"
              },
              {
                "field": "Microsoft.KeyVault/vaults/enableSoftDelete",
                "exists": "false"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
POLICY_RULE
  parameters   = <<PARAMETERS
  {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "'Audit' allows a non-compliant resource to be created, but flags it as non-compliant. 'Deny' blocks the resource creation. 'Disable' turns off the policy."
        },
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Deny"
      }
    }
PARAMETERS
}

data "azurerm_subscription" "current" {}

resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "policyrestrictrbacfalse-assignment"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.policy.id
  description          = "Policy Assignment created for rbac"
  display_name         = var.assign_name
  parameters = jsonencode({
    "effect" : {
      "value" : var.effect,
    }
    }
  )
}
