run "whole_advanced_kitchen" {
  command = apply

  # --- provider for_each ------------------------------------------
  assert {
    condition     = length(oven_ingredient.regional_flour) == 2
    error_message = "north and south rooms each get a flour shelf"
  }

  assert {
    condition     = output.regional_shelves["north"] == "ingredient:regional-flour"
    error_message = "each room's shelf id follows the ingredient:<name> scheme"
  }

  # --- dynamic blocks ---------------------------------------------
  assert {
    condition     = output.steps_count == 4
    error_message = "the cookies recipe in the book has four steps"
  }

  assert {
    condition     = oven_recipe.cookies.steps[0].order == 1
    error_message = "dynamic block content mapped order = index + 1"
  }

  assert {
    condition     = oven_recipe.cookies.steps[3].description == "Roll balls and flatten them on a tray"
    error_message = "the last dynamic step carries the book's text"
  }

  assert {
    condition     = oven_recipe.cookies.outcome != ""
    error_message = "the recipe was actually baked by the provider"
  }

  # --- provider functions -----------------------------------------
  assert {
    condition     = output.preheat_fahrenheit == 356
    error_message = "cookies bake at 180 C = 356 F"
  }

  assert {
    # same servings as the book: fixed+scaled formula returns the base 12
    condition     = output.bake_estimate_minutes == 12
    error_message = "bake_time(cookies, 20) at base servings stays 12 minutes"
  }

  assert {
    condition     = output.dough_verdict == "dough"
    error_message = "8.3 dry-to-liquid is dough, no pastry chef will argue"
  }

  assert {
    condition     = can(regex("^Cookies: book-cookies with 4 steps", output.advanced_report))
    error_message = "the report heredoc composes every dynamic value"
  }
}

run "shrinking_kitchen_set" {
  command = plan

  variables {
    disabled_kitchens = ["south"]
  }

  assert {
    # setsubtract removed the south room's flour; north survives
    condition     = length(oven_ingredient.regional_flour) == 1
    error_message = "disabling south leaves only the north shelf"
  }
}

run "ephemeral_spoon_never_hits_state" {
  command = apply

  # The tasting spoon cannot be asserted (no state entry exists for
  # ephemeral resources) - the assertion is that apply succeeds with
  # the spoon declared, proving ephemeral resources work end to end.
  assert {
    condition     = oven_recipe.cookies.name == "book-cookies"
    error_message = "ephemeral resources do not disturb regular state"
  }
}