# The reusable cookie line: any kitchen can call this module with a
# batch name and servings, and get a full mix-prep-bake pipeline.

terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

variable "batch_name" {
  description = "Name for this cookie batch."
  type        = string
}

variable "servings" {
  description = "How many cookies to pretend to produce."
  type        = number
  default     = 12

  validation {
    condition     = var.servings >= 4 && var.servings <= 48
    error_message = "A cookie batch makes 4 to 48 cookies."
  }
}

variable "temperature" {
  description = "Baking temperature in Celsius."
  type        = number
  default     = 180
}

locals {
  # scale the dough to the batch size, with a pinch of magic numbers
  flour_grams   = var.servings * 14
  butter_grams  = var.servings * 8.5
  sugar_grams   = var.servings * 7.5
  chips_grams   = var.servings * 10
  dough_liq     = var.servings * 4.5
  bake_minutes  = var.servings <= 12 ? 10 : 12
}

resource "oven_mix" "dough" {
  name = "cookie-dough-${var.batch_name}"

  ingredients = {
    flour           = local.flour_grams
    butter          = local.butter_grams
    sugar           = local.sugar_grams
    chocolate-chips = local.chips_grams
    egg             = 14
    water           = local.dough_liq
  }
}

resource "oven_prep" "cream" {
  name             = "cream-${var.batch_name}"
  mode             = "whip"
  duration_minutes = 8
  ingredients      = ["butter", "sugar"]
}

resource "oven_bake" "trays" {
  count = local.bake_minutes == 10 ? 1 : 2

  name             = format("cookies-%s-%02d", var.batch_name, count.index + 1)
  temperature      = var.temperature
  duration_minutes = local.bake_minutes
  mode             = "static"
}

output "dough_id" {
  value = oven_mix.dough.id
}

output "consistency" {
  description = "What the dough feels like (runny/batter/dough)."
  value       = oven_mix.dough.consistency
}

output "tray_ids" {
  value = [for tray in oven_bake.trays : tray.id]
}

output "doneness" {
  value = [for tray in oven_bake.trays : tray.doneness]
}