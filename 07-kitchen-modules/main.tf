terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "cookie-factory"
  chaos_level  = 0
}

locals {
  flavors = {
    classic = {
      servings   = 12
      temperature = 180
    }
    double-cocoa = {
      servings   = 24
      temperature = 170
    }
  }
}

# One cookie line per flavor: modules support for_each exactly like
# resources do.
module "batches" {
  source   = "./moduels/cookies"
  for_each = local.flavors

  servings    = each.value.servings
  temperature = each.value.temperature
}

# A single, hand-tuned batch via count (only when enabled)
variable "emergency_batch" {
  description = "Bake a bonus classic batch?"
  type        = bool
  default     = true
}

module "bonus" {
  source = "./modules/cookies"
  count  = var.emergency_batch ? 1 : 0

  batch_name = "bonus-batch"
  servings   = 8
}

output "consistency_by_flavor" {
  description = "Map of flavor -> dough consistency."
  value = {
    for flavor, line in module.batches : flavor => line.consistency
  }
}

output "tray_ids_by_flavor" {
  description = "Map of flavor -> list of tray ids."
  value = {
    for flavor, line in module.batches : flavor => line.tray_ids
  }
}

locals {
  # module.bonus is count-based, so its value is a single-element list
  # of maps; concat flattens the nested lists into one id list.
  all_trays = concat(
    module.bonus[*].tray_ids,
    [for flavor, line in module.batches : line.tray_ids],
  )

  all_tray_ids = flatten(local.all_trays)
}

output "all_trays_nested" {
  description = "Nested list: bonus trays + one list per flavor."
  value       = local.all_trays
}

output "all_tray_ids" {
  description = "flatten() merges everything into one list."
  value       = local.all_tray_ids
}