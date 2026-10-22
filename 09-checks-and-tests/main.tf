terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

provider "oven" {
  kitchen_name = "safety-kitchen"
  chaos_level  = 1
}

variable "burn_saturday" {
  description = "Flip to true to bake at charcoal territory."
  type        = bool
  default     = false
}

data "oven_oven" "this" {}

# Environment assertion: runs with every plan/apply. It can NOT fail
# the operation - check blocks warn, like `tofu plan` warnings.
check "oven_reaches_bread_temperatures" {
  data "oven_oven" "probe" {}

  assert {
    condition     = data.oven_oven.probe.max_temperature >= 200
    error_message = "this kitchen cannot bake proper bread without 200 °C"
  }
}

resource "oven_ingredient" "flour" {
  name   = "flour"
  amount = 500
  unit   = "g"
}

resource "oven_bake" "saturday_bread" {
  name             = "saturday_bread"
  temperature      = var.burn_saturday ? 200 : 220
  duration_minutes = var.burn_saturday ? 120 : 45
  mode             = "static"

  lifecycle {
    postcondition {
      # self.doneness is this resource's own computed value
      condition     = self.doneness != "golden"
      error_message = "The safety inspector refuses a charcoal loaf. Lower duration_minutes."
    }
  }
}

output "loaf_report" {
  value = {
    doneness   = oven_bake.saturday_bread.doneness
    flour_shelf = oven_ingredient.flour.id
  }

  # Output preconditions are direct children (no lifecycle wrapper):
  # unlike resource postconditions they fail the whole plan/apply.
  precondition {
    condition     = oven_bake.saturday_bread.doneness != "charcoal"
    error_message = "No loaf report will be published for charcoal."
  }
}