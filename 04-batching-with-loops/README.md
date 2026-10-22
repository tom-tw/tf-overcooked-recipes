# Lesson 04 — Batching with loops [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

The trays were numbered by a miscount and the doneness extraction
lost something.

## What should work (from the tests)

- Three pantry shelves addressable by name (`oven_ingredient.pantry["cocoa"]`)
- Cookie trays named `cookie-batch-01`, `cookie-batch-02`, ... (the
  first tray is 01, not 00)
- `local.all_doneness` a **list** of doneness strings, one per tray
- `local.all_golden` true at 180 °C for 12 minutes
- `var.batches = 1` bakes exactly one tray

## Concepts in play

- `count` vs `for_each` (pantry uses for_each; trays use count)
- `count.index` arithmetic inside `format("%02d", ...)`
- `for` expressions building lists and maps
- The splat operator for per-instance attribute extraction

## Workflow

```sh
tofu test    # red → first error → fix → repeat
```

No `tofu init` (dev overrides; repo README).

## Hints

`./HINT.md` — three tiers, then try.