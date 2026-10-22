run "book_drives_pantry" {
  command = apply

  assert {
    condition     = length(oven_ingredient.book) == 5
    error_message = "pancakes list five ingredients in the book"
  }

  assert {
    condition     = oven_ingredient.book["milk"].amount == 300
    error_message = "the milk shelf should carry the book's 300 ml"
  }

  assert {
    condition     = length(oven_tool.book) == 2
    error_message = "pancakes need a whisk and a spatula"
  }

  assert {
    condition     = oven_tool.book["whisk"].kind == "whisk"
    error_message = "tools are keyed and typed after the book"
  }

  assert {
    condition     = can(regex("300 ml milk", output.shopping_list))
    error_message = "the shopping list should start with the milk entry (300 ml milk)"
  }

  assert {
    condition     = output.book_cuisine == "international"
    error_message = "pancakes are classified as international cuisine"
  }

  assert {
    condition     = can(regex("Model   : OVEN-5000", output.capabilities))
    error_message = "the oven data source should report the default model"
  }

  assert {
    condition     = length(data.oven_oven.this.bake_modes) == 4
    error_message = "four bake modes: static, convection, steam, grill"
  }
}