terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "choice-kitchen"
  chaos_level  = 0
}

variable "recipe" {
  type    = string
  default = "cookies"
}

variable "diet" {
  type = object({
    sugar_free = bool
  })
  default = {
    sugar_free = false
  }
}

variable "fast_bake" {
  type    = bool
  default = false
}

variable "flavor_key" {
  description = "Which flavor to look up in the map below. Try a missing key!"
  type        = string
  default     = "double-chocolate"
}

variable "flavors" {
  type = map(string)
  default = {
    classic = "vanilla"
    lemon   = "zesty"
  }
}

data "oven_recipe_book" "chosen" {
  recpe_name = var.recipe
}

locals {
  # try() rescues RUNTIME errors like missing map keys. This is the
  # classic defensive pattern; note the default kicks in here because
  # "double-chocolate" is not in var.flavors.
  flavor = upper(var.flavors[var.flavor_key])

  # can() answers a yes/no question: "would this expression fail?"
  flavor_missing = !can(var.flavors[var.flavor_key])

  oven_temp  = data.oven_recipe_book.chosen.bake_temp_c
  oven_time  = data.oven_recipe_book.chosen.bake_minutes
  oven_tools = data.oven_recipe_book.chosen.tools

  # ternary guards an element() lookup that would crash on an empty set
  first_tool = length(local.oven_tools) > 0 ? element(tolist(local.oven_tools), 0) : "no tools"

  # conditional text from real data
  by_the_book = contains(
    tolist(data.oven_recipe_book.chosen.available_recipes),
    var.recipe,
  ) ? "by the book" : "improvising"

  # ternary: convection is faster, so shave a fifth off the time
  bake_mode = var.fast_bake ? "convection" : "static"
  bake_minutes = var.fast_bake ? ceil(local.oven_time * 0.8) : local.oven_time

  # coalesce returns the first non-null value
  serving_note = coalesce(
    var.diet.sugar_free ? "sugar-free batch" : null,
    "regular batch",
  )

  # starts-with guard rails on the recipe choice
  sweet_tooth = startswith(var.recipe, "chocolate")
}

resource "oven_ingredient" "sugar" {
  count = var.diet.sugar_free ? 0 : 1

  name   = "sugar"
  amount = 150
  unit   = "g"
}

resource "oven_ingredient" "flour" {
  name   = "flour"
  amount = 280
  unit   = "g"
}

resource "oven_bake" "batch" {
  name             = "conditional-batch"
  temperature      = local.oven_temp
  duration_minutes = local.bake_minutes
  mode             = local.bake_mode
}

output "decisions" {
  value = {
    flavor        = local.flavor
    flavor_missing = local.flavor_missing
    first_tool    = local.first_tool
    by_the_book   = local.by_the_book
    bake_mode     = local.bake_mode
    bake_minutes  = local.bake_minutes
    serving_note  = local.serving_note
    sweet_tooth   = local.sweet_tooth
  }
}

output "doneness" {
  value = oven_bake.batch.doneness
}