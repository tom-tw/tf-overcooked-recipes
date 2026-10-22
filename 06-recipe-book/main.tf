terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "book-kitchen"
  chaos_level  = 0
}

data "oven_recipe_book" "pancakes" {
  recipe_name = "pancakes"
}

data "oven_oven" "this" {}

# Every ingredient the book asks for becomes a real shelf, keyed by
# the ingredient name from the data source.
resource "oven_ingredient" "book" {
  for_each = {
    for ing in data.oven_recipe_book.pancakes.ingredients : ing.unit => ing
  }

  name   = each.key
  amount = each.value.amount
  unit   = each.value.unit
}

# Every tool the recipe expects is purchased (tool kinds are valid
# kitchen implements: whisk, mixer, spatula...).
resource "oven_tool" "book" {
  for_each = data.oven_recipe_book.pancakes.tools

  name = "book-${each.key}"
  kind = each.key
}

locals {
  # zip ingredients into a shopping list string
  shopping_list = join(", ", [
    for ing in data.oven_recipe_book.pancakes.ingredients :
    format("%s %s %s", ing.unit, ing.name, ing.amount)
  ])

  # count-based prep steps straight from the book (list of strings)
  step_names = [
    for i, step in data.oven_recipe_book.pancakes.steps :
    format("%02d-%s", i + 1, lower(replace(step, " ", "-")))
  ]

  capabilities = <<-CAPS
    Kitchen : ${data.oven_oven.this.kitchen_name}
    Model   : ${data.oven_oven.this.oven_model} (max ${data.oven_oven.this.max_temperature} °C)
    Modes   : ${join(", ", data.oven_oven.this.bake_modes)}
    Chaos   : ${data.oven_oven.this.chaos_level}
  CAPS
}

output "shopping_list" {
  description = "Ingredient list computed from the data source."
  value       = local.shopping_list
}

output "step_names" {
  value = local.step_names
}

output "capabilities" {
  value = local.capabilities
}

output "book_cuisine" {
  value = data.oven_recipe_book.pancakes.cuisine
}