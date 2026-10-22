# Lesson 01 — Your first kitchen [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

The tests are the specification. The config has been overcooked —
there are defects hiding in it. Read the errors carefully: each one
tells you more than you think.

## What should work (from the tests)

- An `oven_ingredient` named **flour**, shelved with `amount = 500` in
  grams, whose pantry barcode reads `ingredient:flour`
- An `oven_tool` named **learning-whisk** of kind `whisk` with sticker
  `tool:learning-whisk`
- `stored_at` filled in by the provider, looking like an RFC3339
  timestamp (e.g. `2026-10-21T19:10:49Z`)

## Concepts in play

- `terraform`, `provider` and `resource` blocks
- Required vs computed resource arguments
- Resource addresses: `oven_ingredient.flour`

## Workflow

```sh
tofu test          # red: read the FIRST error only, fix, repeat
tofu test          # ... until: Success!
```

Do **not** run `tofu init` in this repo — `dev_overrides` make it
unnecessary (and it errors on current OpenTofu).

## Hints

`./HINT.md` has three staged hints. Read one tier at a time and try
again after each — the third tier is as close to the answer as you can
get without seeing the code.