# Lesson 05 — Conditionals and expressions [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

The recipe lookup lost a letter, and the flavor lookup lost its
safety net.

## What should work (from the tests)

- The recipe book data source serves `cookies`: bake at 180 °C,
  static mode, golden result
- The missing flavor key (`double-chocolate` is not in `var.flavors`)
  resolves to `house-fallback`, with `flavor_missing` true; the
  existing key `lemon` resolves to `ZESTY`
- `fast_bake = true` switches to convection and trims 12 → 10 minutes
- `diet.sugar_free = true` removes the sugar shelf and the serving
  note becomes "sugar-free batch"
- The first expected tool reads as `mixer` (alphabetical luck of a set)

## Concepts in play

- `try()` and `can()` around **catchable runtime errors** (map keys)
- Data source reads as **hard failures** (uncatchable!)
- Ternaries, `coalesce`, `startswith`, `contains`
- `count` as a conditional (0 or 1 sugar shelves)

## Workflow

```sh
tofu test    # red → first error → fix → repeat
```

No `tofu init` (dev overrides; repo README).

## Hints

`./HINT.md` — three tiers, then try.