# Lesson 03 — Locals and functions [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

The Sunday menu template and the chef's temperature conversions were
overcooked.

## What should work (from the tests)

- `oven_ingredient.flour` stocks `servings × 125` grams
- `output.oven_temp_fahrenheit` reads 356 for an oven set to 180 °C
- `output.batter_feel` classifies 300 g liquid + 250 g dry as one
  specific consistency (the pastry word, not the measurement)
- The heredoc menu contains the lines `Flour needed : 500 g` and
  `Oven set to  : 356`
- With 12 servings, the note reads `This is a big batch.` and the bake
  estimate for pancakes becomes 20 minutes

## Concepts in play

- `locals`, template conditional directives (`%{ if }` / `%{ else }`)
- Heredocs (`<<-`)
- Provider functions from the `oven` provider: temperature conversion,
  bake-time estimation, ratio classification
- Built-ins: `title`, `join`, `upper`

## Workflow

```sh
tofu test    # red → first error → fix → repeat
```

No `tofu init` (dev overrides; repo README).

## Hints

`./HINT.md` — three tiers, then try.