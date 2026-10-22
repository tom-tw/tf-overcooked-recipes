run "locals_and_functions" {
  command = plan

  assert {
    condition     = oven_ingredient.flour.amount == 500
    error_message = "local flour_grams = servings * 125 should be 500 g"
  }

  assert {
    condition     = output.oven_temp_fahrenheit == 356
    error_message = "provider function convert_temp(180 C) should be 356 F"
  }

  assert {
    condition     = output.batter_feel == "batter"
    error_message = "mix_ratio(300 liquid, 250 dry) is batter territory"
  }

  assert {
    condition     = can(regex("Flour needed : 500 g", output.menu))
    error_message = "the heredoc menu should contain the flour line"
  }

  assert {
    condition     = can(regex("Oven set to  : 356", output.menu))
    error_message = "the heredoc menu should show the converted temperature"
  }
}

run "big_batch_report" {
  command = plan

  variables {
    servings = 12
  }

  assert {
    condition     = output.batch_note == "This is a big batch."
    error_message = "12 servings is a big batch by any measure"
  }

  # more servings -> longer bake, using the bake_time provider function
  assert {
    condition     = output.pancake_bake_minutes == 20
    error_message = "bake_time(pancakes, 12) = 5 + 0.5*10*(12/4) = 20 minutes"
  }
}