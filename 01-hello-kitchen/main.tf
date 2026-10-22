terraform {
  required_version = ">= 1.9"

  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "learning-kitchen"
  chaos_level  = 0
}

resource "oven_ingredient" "flour" {
  name   = "flour"
  amont  = 500
  unit   = "g"

resource "oven_tool" "whisk" {
  name = "learning-whisk"
  kind = "whisk"
}

output "flour_shelf_id" {
  description = "The pantry barcode the provider generated."
  value       = oven_ingredient.flour.id
}

output "flour_stored_at" {
  description = "When the provider claims to have shelved the flour."
  value       = oven_ingredient.flour.stored_at
}

output "tool_report" {
  description = "A tiny string template combining attributes."
  value       = "Bought ${oven_tool.whisk.kind} '${oven_tool.whisk.name}' (clean=${oven_tool.whisk.clean})"
}