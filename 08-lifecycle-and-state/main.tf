terraform {
  required_providers {
    oven = {
      source = "tom-tw/oven"
    }
  }
}

# Default kitchen
provider "oven" {
  kitchen_name = "home-kitchen"
  chaos_level  = 0
}

# A second kitchen (provider configuration alias). Resources opt in
# with `provider = oven.beach_house`. No state is shared between the
# two kitchens, exactly like multi-region/aliased cloud providers.
provider "oven" {
  alias        = "beach_house"
  kitchen_name = "beach-house-kitchen"
  chaos_level  = 0
}

# Renaming this resource (the address) destroys nothing: the moved
# block tells tofu the identity survived the refactor. Comment it out
# to see the plan switch to destroy+create.
resource "oven_ingredient" "flour_main" {
  name   = "flour"
  amount = 500
  unit   = "g"
}

moved {
  from = oven_ingredient.flour_main
  to   = oven_ingredient.flour
}

resource "oven_tool" "stand-mixer" {
  name = "stand-mixer"
  kind = "mixer"

  lifecycle {
    # Upgrade path: the new mixer arrives before the old one leaves.
    create_before_destroy = true
  }
}

resource "oven_tool" "heirloom" {
  name  = "grandmas-knife"
  kind  = "knife"
  brand = "Hand-engraved by grandpa"

  lifecycle {
    # Family legend says grandpa engraved this. Any config change to
    # the label is ignored: plan never reverts it.
    ignore_changes = [brand]
  }
}

# Adopting an existing shelf. Apply once with this block, then remove
# the block: the resource stays imported in state (tracked by
# infrastructure code from now on).
resource "oven_ingredient" "adopted" {
  name   = "adopted-flour"
  amount = 250
  unit   = "g"
}

data "oven_oven" "home" {}

data "oven_oven" "beach" {
  provider = oven.beachhouse
}

resource "oven_ingredient" "beach_salt" {
  provider = oven.beach_house

  name   = "sea-salt"
  amount = 900
  unit   = "tsp"
}

locals {
  report = <<-REPORT
    Flours shelved at home      : ${oven_ingredient.flour_main.stored_at}
    Beach kitchen sees          : ${data.oven_oven.beach.kitchen_name}
    Beach max temperature       : ${data.oven_oven.beach.max_temperature} °C
    Home max temperature        : ${data.oven_oven.home.max_temperature} °C
  REPORT
}

output "moved_resource_id" {
  description = "Same shelf, new address; moved blocks avoid the rebuild."
  value       = oven_ingredient.flour_main.id
}

output "adopted_shelf_id" {
  value = oven_ingredient.adopted.id
}

output "kitchen_report" {
  value = local.report
}