# Module tests pin chaos to zero via an inline provider block.
provider "oven" {
  kitchen_name = "module-test-kitchen"
  chaos_level = 0
}

# Module tests run the module in isolation: `tofu test` inside the
# module directory treats it as the root module under test.
#
# Variable validation (servings outside 4..48) is enforced by
# `tofu validate`; see the lesson README to see it fail on purpose.

run "classic_batch" {
  command = apply

  variables {
    batch_name = "test-classic"
    servings   = 12
  }

  assert {
    condition     = output.consistency == "dough"
    error_message = "cookie dough ratios (494 g dry / 54 g liquid) are unmistakably dough"
  }

  assert {
    condition     = length(output.tray_ids) == 1
    error_message = "12 servings bake one tray"
  }

  assert {
    condition     = output.doneness[0] == "golden"
    error_message = "180 C for 10 min is golden"
  }
}

run "double_batch" {
  command = apply

  variables {
    batch_name = "test-double"
    servings   = 24
  }

  assert {
    condition     = length(output.tray_ids) == 2
    error_message = "24 servings need two trays"
  }

  # the dough composition scales: 24 servings -> 336 g flour
  assert {
    condition     = can(regex("^mix:cookie-dough-test-double$", output.dough_id))
    error_message = "dough id carries the module batch name"
  }
}