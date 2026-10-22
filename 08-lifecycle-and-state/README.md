# Lesson 08 — Lifecycle, state surgery, two kitchens [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

A `moved` block points the wrong way and one kitchen lost its name.

## What should work (from the tests)

- The renamed shelf keeps its identity: `oven_ingredient.flour_main.id`
  is `ingredient:flour` — the `moved` block maps the *old, now
  undeclared* address onto the *new, declared* one without destroying
- The adopted shelf reads back `ingredient:adopted-flour` with amount
  reconciled to 250
- `data.oven_oven.home` serves `home-kitchen`; the aliased beach data
  source serves `beach-house-kitchen`
- The beach salt shelf carries 900 tsp in the other kitchen
- The kitchen report shows each kitchen's own max temperature

## Concepts in play

- `moved` blocks: from = the address leaving the config, to = the
  address replacing it
- Provider configuration aliases and the `provider` meta-argument
- `lifecycle` blocks (`create_before_destroy`, `ignore_changes`)
- Aliases are exact identifiers

## Workflow

```sh
tofu test    # red → first error → fix → repeat
```

No `tofu init` (dev overrides; repo README).

## Hints

`./HINT.md` — three tiers, then try.