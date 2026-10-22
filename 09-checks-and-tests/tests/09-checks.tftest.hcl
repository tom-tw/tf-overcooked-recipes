run "healthy_saturday" {
  command = apply

  assert {
    condition     = oven_bake.saturday_bread.doneness == "well-done"
    error_message = "220 C for 45 min is a well-done sourdough"
  }

  assert {
    condition     = output.loaf_report.flour_shelf == "ingredient:flour"
    error_message = "the loaf report should reference the flour shelf"
  }
}

run "charcoal_is_refused" {
  command = apply

  variables {
    burn_saturday = true
  }

  # 200 C for 120 min -> doneness charcoal -> the lifecycle
  # postcondition refuses the apply. expect_failures accepts the
  # resource that reported the error.
  expect_failures = [resource.oven_bake.saturday_bread]
}