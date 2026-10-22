# Lesson 02 — Variables and validation [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

Someone reseasoned the pantry's variable defaults and one output went
address-hunting.

## What should work (from the tests)

- A flour shelf driven by the `flour_amount`/`flour_unit` variables
- `extras.salt_amount = 2500` override produces one salt shelf carrying
  2500 tsp
- `extras.salt_stocked = false` removes the salt shelf entirely
- Variable validation still guards silly values (the tests do not
  trigger it, but it must keep working)

## Concepts in play

- `variable` blocks: `type`, `default`, `description`, `sensitive`
- `validation` blocks and why they fire before any resource
- Object variables and run-block overrides in `tofu test`
- Addressing `count`-created instances (spoiler-free: instances are
  zero-based — how many *exist* here?)

## Workflow

```sh
tofu test    # red → read the first error → fix main.tf → repeat
```

No `tofu init` in this repo (dev overrides; see the repo README).

## Hints

`./HINT.md` — three tiers. Try again after each tier.