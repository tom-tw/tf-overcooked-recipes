# Lesson 08 applies real resources (moved + import blocks included),
# so the run uses apply; the assertions prove each state operation.

run "lifecycle_and_state" {
  command = apply

  assert {
    condition     = oven_ingredient.flour_main.id == "ingredient:flour"
    error_message = "the moved block kept the original shelf identity"
  }

  assert {
    condition     = oven_ingredient.adopted.id == "ingredient:adopted-flour"
    error_message = "the import block adopted the shelf under its id"
  }

  assert {
    condition     = oven_ingredient.adopted.amount == 250
    error_message = "after import the config reconciled the amount"
  }

  assert {
    condition     = data.oven_oven.beach.kitchen_name == "beach-house-kitchen"
    error_message = "the aliased data source reads the other kitchen"
  }

  assert {
    condition     = data.oven_oven.home.kitchen_name == "home-kitchen"
    error_message = "the default provider serves the home kitchen"
  }

  assert {
    condition     = oven_ingredient.beach_salt.amount == 900
    error_message = "beach ingredients live in the aliased kitchen"
  }

  assert {
    condition     = can(regex("Home max temperature\\s+: 250", output.kitchen_report))
    error_message = "both kitchens show their own max_temperature"
  }
}