# Lesson 09 — Checks, conditions and tests [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

Here the overcooking is *invisible at first glance*: failures arrive
from the wrong culprit, and a safety system rejects good bread.

## What should work (from the tests)

- Run 1 (`healthy_saturday`): the bread bakes to `well-done` at
  220 °C / 45 min and the loaf report references the flour shelf
- Run 2 (`charcoal_is_refused`): with 200 °C / 120 min the resource's
  own safeguard must *reject* the bake, and `expect_failures` sees it
- The `check` block about oven capability keeps passing

## Concepts in play

- `check` blocks vs `lifecycle.postcondition` vs output `precondition`
- `expect_failures` on the resource that reports the error
- The provider's chaos engine: random-looking failures have a cause —
  read the provider block before debugging your code. (The dial is a
  number between 0 and 1; golden lessons keep it at 0.)

## Workflow

```sh
tofu test    # red → whose fault is it TODAY? → fix → repeat
```

If an error mentions gas, cats or elves, your fixes so far are fine —
that is the kitchen misbehaving, not your config.

## Hints

`./HINT.md` — three tiers, then try.