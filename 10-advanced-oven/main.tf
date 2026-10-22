terraform {
  required_version = ">= 1.10"

  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

# Default configuration (north wing of the house)
provider "oven" {
  kitchen_name = "main-kitchen"
  chaos_level  = 0
}

# ------------------------------------------------------------------
# Provider for_each (OpenTofu 1.9+): N dynamic instances of the
# provider, one kitchen per room. for_each requires an alias.
# ------------------------------------------------------------------
variable "kitchens" {
  description = "Rooms with their own provider instance."
  type        = set(string)
  default     = ["north", "south"]
}

variable "disabled_kitchens" {
  description = "Rooms shutting down (remove resources first via setsubtract)."
  type        = set(string)
  default     = []
}

provider "oven" {
  alias = "by_room"

  for_each     = var.kitchens
  kitchen_name = "kitchen-${each.key}"
  chaos_level  = 0
}

# The resource for_each is a SUBSET of the provider for_each: shrinking
# var.disabled_kitchens-adjacent sets destroys cleanly, as the
# OpenTofu docs prescribe.
resource "oven_ingredient" "regional_flour" {
  for_each = setsubtract(var.kitchens, var.disabled_kitchens)
  provider = oven[each.key]

  name   = "regional-flour"
  amount = 500
  unit   = "g"
}

# ------------------------------------------------------------------
# Dynamic blocks straight from the recipe book
# ------------------------------------------------------------------
data "oven_recipe_book" "cookies" {
  recipe_name = "cookies"
}

resource "oven_recipe" "cookies" {
  name             = "book-cookies"
  servings         = data.oven_recipe_book.cookies.servings
  temperature      = data.oven_recipe_book.cookies.bake_temp_c
  duration_minutes = data.oven_recipe_book.cookies.bake_minutes

  dynamic "steps" {
    for_each = [
      for i, text in data.oven_recipe_book.cookies.steps : {
        order       = i + 1
        description = text
      }
    ]
    content {
      order       = steps.value.number
      description = steps.value.text
    }
  }
}

# ------------------------------------------------------------------
# Ephemeral resources (OpenTofu 1.10+): the spoon only exists while
# the apply runs and never reaches state. Ephemeral values may only
# flow to other ephemeral resources, so we simply declare it here;
# its `verdict` is real during the apply.
# ------------------------------------------------------------------
ephemeral "oven_tasting_spoon" "dough" {
  name = "cookie-dough"
}

# ------------------------------------------------------------------
# Provider functions as first-class expression helpers
# ------------------------------------------------------------------
locals {
  preheat_fahrenheit = provider::oven::convert_temp(
    data.oven_recipe_book.cookies.bake_temp_c, "C", "F"
  )
  bake_estimate = provider::oven::bake_time(
    "cookies", data.oven_recipe_book.cookies.servings
  )
  dough_verdict = provider::oven::mix_ratio(60, 500)

  dynamic_step_count = length(oven_recipe.cookies.steps)
}

output "advanced_report" {
  description = "The dynamic block turned the book's step list into real blocks."
  value       = "Cookies: ${oven_recipe.cookies.name} with ${local.dynamic_step_count} steps, preheat ${local.preheat_fahrenheit} °F, est. ${local.bake_estimate} min (${local.dough_verdict})"
}

output "steps_count" {
  value = local.dynamic_step_count
}

output "preheat_fahrenheit" {
  value = local.preheat_fahrenheit
}

output "bake_estimate_minutes" {
  value = local.bake_estimate
}

output "dough_verdict" {
  value = local.dough_verdict
}

output "regional_shelves" {
  description = "One flour shelf per room, each in its own provider instance."
  value = {
    for room, shelf in oven_ingredient.regional_flour : room => shelf.id
  }
}

output "spoon_verdict" {
  description = "What the tasting spoon said about the dough."
  value       = ephemeral.oven_tasting_spoon.dough.verdict
}