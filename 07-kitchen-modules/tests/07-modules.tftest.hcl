run "flavor_lines" {
  command = apply

  assert {
    condition     = length(module.batches) == 2
    error_message = "two flavors, two cookie lines"
  }

  assert {
    condition     = module.batches["classic"].consistency == "dough"
    error_message = "the classic line makes genuine dough"
  }

  assert {
    condition     = length(module.batches["double-cocoa"].tray_ids) == 2
    error_message = "24 servings need two trays in the double-cocoa line"
  }

  assert {
    condition     = alltrue([for flavor, line in module.batches : line.doneness[0] == "golden"])
    error_message = "every flavor's first tray should be golden"
  }

  assert {
    condition     = length(output.all_tray_ids) == 4
    error_message = "one bonus tray + 1 classic tray + 2 double-cocoa trays = 4"
  }

  assert {
    # the nested output shows the shape flatten() receives
    condition     = length(output.all_trays_nested) == 3
    error_message = "nested shape: one bonus list + two flavor lists"
  }
}

run "no_emergency_batch" {
  command = plan

  variables {
    emergency_batch = false
  }

  assert {
    condition     = length(output.all_tray_ids) == 3
    error_message = "without the bonus batch the flavor lines still make 3 trays"
  }
}