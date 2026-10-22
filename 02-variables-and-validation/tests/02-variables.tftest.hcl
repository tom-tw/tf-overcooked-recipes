run "variable_driven_pantry" {
  # apply so computed attributes (ids) are known
  command = apply

  assert {
    condition     = oven_ingredient.flour.id == "ingredient:flour"
    error_message = "flour shelf should exist regardless of amounts"
  }

  assert {
    condition     = length(oven_ingredient.salt) == 1
    error_message = "salt_stocked defaults to true: one salt shelf expected"
  }
}

run "object_variable_in_action" {
  command = apply

  # run blocks can override root variables directly (OpenTofu 1.8+)
  variables {
    extras = {
      salt_stocked = true
      salt_amount  = 2500
    }
  }

  assert {
    condition     = oven_ingredient.salt[0].amount == 2500
    error_message = "the run block override should lift salt to 2500 tsp"
  }
}

run "no_salt_shelf" {
  command = plan

  variables {
    extras = {
      salt_stocked = false
      salt_amount  = 0
    }
  }

  assert {
    condition     = length(oven_ingredient.salt) == 0
    error_message = "salt_stocked=false should remove the salt shelf"
  }
}