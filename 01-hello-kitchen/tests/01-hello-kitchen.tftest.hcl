run "first_kitchen" {
  # apply instead of plan so computed attributes (stored_at) are known
  command = apply

  assert {
    condition     = oven_ingredient.flour.id == "ingredient:flour"
    error_message = "the pantry barcode must follow ingredient:<name>"
  }

  assert {
    condition     = oven_tool.whisk.id == "tool:learning-whisk"
    error_message = "the tool sticker must follow tool:<name>"
  }

  assert {
    condition     = can(regex("^\\d{4}-\\d{2}-\\d{2}T", oven_ingredient.flour.stored_at))
    error_message = "stored_at should look like an RFC3339 timestamp"
  }
}