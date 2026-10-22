run "regular_batch" {
  command = apply

  assert {
    condition     = length(oven_ingredient.sugar) == 1
    error_message = "default diet keeps the sugar shelf"
  }

  assert {
    condition     = oven_bake.batch.mode == "static"
    error_message = "fast_bake=false should bake in static mode"
  }

  assert {
    condition     = oven_bake.batch.temperature == 180
    error_message = "cookies bake at 180 C from the recipe book"
  }

  assert {
    condition     = oven_bake.batch.doneness == "golden"
    error_message = "180 C for 12 min: golden"
  }

  # try() catches the missing map key: "double-chocolate" is absent
  assert {
    condition     = output.decisions.flavor == "house-fallback"
    error_message = "a missing map key must trigger the try() fallback"
  }

  assert {
    condition     = output.decisions.flavor_missing
    error_message = "can() should notice the missing key"
  }

  assert {
    condition     = output.decisions.first_tool == "mixer"
    error_message = "element(tolist(set), 0) picks alphabetically first tool"
  }
}

run "known_flavor_key" {
  command = plan

  variables {
    flavor_key = "lemon"
  }

  assert {
    condition     = output.decisions.flavor == "ZESTY"
    error_message = "an existing map key skips the try() fallback (and is uppercased)"
  }

  assert {
    condition     = !output.decisions.flavor_missing
    error_message = "can() should see the key exists"
  }
}

run "fast_convection_batch" {
  command = plan

  variables {
    fast_bake = true
  }

  assert {
    condition     = oven_bake.batch.mode == "convection"
    error_message = "fast_bake=true switches to convection"
  }

  assert {
    condition     = oven_bake.batch.duration_minutes == 10
    error_message = "convection shaves 20%: 12 -> 10 minutes"
  }
}

run "sugar_free_batch" {
  command = plan

  variables {
    diet = {
      sugar_free = true
    }
  }

  assert {
    condition     = length(oven_ingredient.sugar) == 0
    error_message = "sugar_free removes the sugar shelf entirely"
  }

  assert {
    condition     = output.decisions.serving_note == "sugar-free batch"
    error_message = "coalesce prefers the sugar-free note when it exists"
  }
}

# Try this manually to see a hard data-source failure:
#   tofu plan -var 'recipe=grandma-secret-cake'
# Data source reads that fail CANNOT be rescued by try() and are not
# even accepted as expect_failures targets; the provider lists every
# recipe it knows so you can self-correct.