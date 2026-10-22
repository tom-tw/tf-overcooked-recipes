terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "batch-kitchen"
  chaos_level  = 0
}

variable "pantry" {
  description = "Dry ingredients to stock, gram amounts."
  type        = map(number)
  default = {
    flour = 500
    sugar = 150
    cocoa = 60
  }
}

variable "batches" {
  description = "How many cookie batches to bake tonight."
  type        = number
  default     = 3

  validation {
    condition     = var.batches >= 1 && var.batches <= 6
    error_message = "Between 1 and 6 batches, please: this is a home kitchen."
  }
}

# for_each: one shelf per pantry entry, addressable by name
resource "oven_ingredient" "pantry" {
  for_each = var.pantry

  name   = each.key
  amount = each.value
  unit   = "g"
}

# count: three identical trays, addressable by index
resource "oven_bake" "cookies" {
  count = var.batches

  name             = format("cookie-batch-%02d", count.index)
  temperature      = 180
  duration_minutes = 12
  mode             = "static"
}

locals {
  # for expression: list of shelf ids (sorted for stable output)
  shelf_ids = [for name, ing in oven_ingredient.pantry : ing.id]

  # for expression: map of tray -> doneness
  tray_doneness = {
    for tray in oven_bake.cookies : tray.name => tray.doneness
  }

  # classic splat on count-based instances (quick list extraction)
  all_doneness = oven_bake.cookies.doneness

  # combine the for expression with alltrue for a verdict
  all_golden = alltrue([for tray in oven_bake.cookies : tray.doneness == "golden"])

  # every expression, one summary
  summary = "Stocked ${length(local.shelf_ids)} shelves and baked ${length(oven_bake.cookies)} batches: ${join(", ", keys(local.tray_doneness))}"
}

output "shelf_ids" {
  value = local.shelf_ids
}

output "tray_doneness" {
  value = local.tray_doneness
}

output "all_golden" {
  value = local.all_golden
}

output "summary" {
  value = local.summary
}