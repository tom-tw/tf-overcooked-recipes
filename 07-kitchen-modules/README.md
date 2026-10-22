# Lesson 07 — Kitchen modules [OVERCOOKED]

Your mission: make `tofu test` pass in this directory (and its module's
own suite in `modules/cookies`).

The cookie production line is a **module** you instantiate per flavor.
Someone overcooked the wiring between the root module and the
cookie-line module.

## One-time setup for THIS lesson only

Configurations with **local modules** need their modules installed:

```sh
tofu init
# prints a scary "Failed to resolve provider packages" error — expected
# with dev_overrides; the local module still gets installed. Run it
# once, then work with `tofu test`.
```

## What should work (from the tests)

- Two cookie lines, one per flavor (`classic`, `double-cocoa`),
  each producing the right tray count: 12 servings → 1 tray,
  24 servings → 2 trays
- Dough consistency `dough` for the classic line
- `flatten()`-ed tray list of length 4 (bonus batch included)
- Disabling `emergency_batch` leaves the flavor lines intact

## Concepts in play

- `module` blocks: `source`, `for_each`, required inputs
- Module outputs and `flatten`/`concat`
- The module's own test suite under `modules/cookies`

## Hints

`./HINT.md` — three tiers, one at a time. Do not open the module's
source; fix the root wiring only.