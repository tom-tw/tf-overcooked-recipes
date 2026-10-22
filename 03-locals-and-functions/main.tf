terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "sunday-kitchen"
  chaos_level  = 0
}

variable "chef_name" {
  type    = string
  default = "Robin"
}

variable "servings" {
  type    = number
  default = 4
}

locals {
  # string interpolation works everywhere
  kitchen_label = "${title(var.chef_name)}'s Sunday Kitchen"

  # math on variables
  flour_grams = var.servings * 125

  # provider functions are available like built-ins
  oven_temp_fahrenheit = provider::oven::convert_temp(180, "C")
  pancake_bake_minutes = provider::oven::bake_time("pancakes", var.servings)
  batter_feel          = provider::oven::mix_ratio(300, 250)

  # a couple of built-ins for good measure
  tools_note = join(", ", ["whisk", "spatula", "mixer"])
  uppercase  = upper("flour")

  # template with a conditional directive
  batch_size_note = "This is a %{ if var.servings > 2 }big batch%{ else }cozy little batch."

  # indentation-preserving heredoc, the cleanest way to write reports
  menu = <<-MENU
    === ${local.kitchen_label} ===
    Flour needed : ${local.flour_grams} g
    Oven set to  : ${local.oven_temp_fahrenheit} °F (${180} °C)
    Bake time    : ${local.pancake_bake_minutes} minutes
    Batter feels : ${local.batter_feel}
    Tools        : ${local.tools_note}
  MENU
}

resource "oven_ingredient" "flour" {
  name   = "flour"
  amount = local.flour_grams
  unit   = "kg"
}

output "menu" {
  value = local.menu
}

output "batch_note" {
  value = local.batch_size_note
}

output "oven_temp_fahrenheit" {
  value = local.oven_temp_fahrenheit
}

output "pancake_bake_minutes" {
  value = local.pancake_bake_minutes
}

output "batter_feel" {
  value = local.batter_feel
}