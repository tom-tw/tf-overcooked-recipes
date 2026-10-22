run "pantry_shelves" {
  command = apply

  assert {
    condition     = length(oven_ingredient.pantry) == 3
    error_message = "three pantry entries should become three shelves"
  }

  assert {
    condition     = oven_ingredient.pantry["cocoa"].id == "ingredient:cocoa"
    error_message = "for_each shelves are addressable by their key"
  }

  assert {
    condition     = length(local.shelf_ids) == 3
    error_message = "the for expression should collect three ids"
  }
}

run "cookie_trays" {
  command = apply

  assert {
    condition     = length(oven_bake.cookies) == 3
    error_message = "three batches by default"
  }

  assert {
    condition     = oven_bake.cookies[0].name == "cookie-batch-01"
    error_message = "count-indexed names should start at 01"
  }

  assert {
    condition     = local.all_golden
    error_message = "180 C for 12 min is golden across every tray"
  }

  assert {
    condition     = local.tray_doneness["cookie-batch-02"] == "golden"
    error_message = "the map keyed by tray name should be golden"
  }
}

run "single_batch" {
  command = plan

  variables {
    batches = 1
  }

  assert {
    condition     = length(oven_bake.cookies) == 1
    error_message = "turning var.batches to 1 should bake one tray"
  }
}