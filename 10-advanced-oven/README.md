# Lesson 10 — The advanced oven [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

The finale was overcooked in three places: provider instances lost
their alias reference, the dynamic block reads attributes that do not
exist, and an ephemeral value tried to sneak out of the apply.

## What should work (from the tests)

- Two ingredient shelves — one per room (`north`, `south`), each baked
  in its own provider instance, ids `ingredient:regional-flour`
- The cookies recipe built with **dynamic** steps: 4 steps from the
  recipe book, orders 1..4, last description from the book
- `output.preheat_fahrenheit` = 356, bake estimate = 12 minutes,
  dough verdict `dough`
- `disabled_kitchens = ["south"]` leaves exactly one shelf
- The tasting spoon completes the apply (its values never reach state)

## Concepts in play

- OpenTofu 1.9+ provider `for_each`: instances selected as
  `alias.instance-key`
- `dynamic` blocks: the `for_each` iterator object vs what `content`
  may read
- OpenTofu 1.10+ ephemeral resources and their one-way scoping rules
- `setsubtract` for provider-instance-safe shrinking

## Workflow

```sh
tofu test    # red → first error → fix → repeat
```

No `tofu init` (dev overrides; repo README).

## Hints

`./HINT.md` — three tiers, then try.