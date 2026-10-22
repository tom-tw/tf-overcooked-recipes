terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "saturday-kitchen"
  chaos_level  = 0
}

variable "flour_amount" {
  type        = number
  description = "How much flour to stock, in the unit below."
  default     = 500

  validation {
    condition     = var.flour_amount >= 100 && var.flour_amount <= 2000
    error_message = "5 g of flour? Are you seasoning a soup? Stock between 100 g and 2 kg."
  }
}

variable "flour_unit" {
  type    = string
  default = "pounds"

  validation {
    condition     = contains(["g", "kg"], var.flour_unit)
    error_message = "The flour shelf handles grams or kilograms only."
  }
}

variable "kitchen_title" {
  type        = string
  description = "Friendly name for signage above the door."
  default     = "Saturday Kitchen"
}

variable "family_secret_recipe" {
  type        = string
  description = "Nobody may see this. Demonstrates sensitive variables."
  default     = "grandma's secret cocoa ratio"
  sensitive   = true
}

variable "extras" {
  type = object({
    salt_stocked = bool
    salt_amount  = number
  })
  description = "Whether to keep a salt shelf and how much."
  default = {
    salt_stocked = true
    salt_amount  = 250
  }
}

resource "oven_ingredient" "flour" {
  name   = "flour"
  amount = var.flour_amount
  unit   = var.flour_unit
}

resource "oven_ingredient" "salt" {
  count = var.extras.salt_stocked ? 1 : 0

  name   = "salt"
  amount = var.extras.salt_amount
  unit   = "tsp"
}

locals {
  sign = "Welcome to ${title(var.kitchen_title)}!"
}

output "sign" {
  value = local.sign
}

output "salt_shelf" {
  description = "Salt shelf id, or null when not stocked."
  value       = var.extras.salt_stocked ? oven_ingredient.salt[2].id : null
}

output "secret_recipe" {
  value     = "Tonight we bake: ${var.family_secret_recipe}"
  sensitive = true
}

output "flour_report" {
  value = "${var.flour_amount} ${var.flour_unit} of flour on the shelf"
}