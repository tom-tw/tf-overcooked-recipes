# Lesson 06 — The recipe book [OVERCOOKED]

Your mission: make `tofu test` pass in this directory.

Data sources are honest here — the bugs are all in what this lesson
derives from them.

## What should work (from the tests)

- Five ingredient shelves built from `data.oven_recipe_book.pancakes.ingredients`,
  each keyed and named after the *ingredient* (e.g. `oven_ingredient.book["milk"]`
  carries the book's 300 ml)
- Two purchased tools, one per expected tool kind, kind = tool name
- The shopping list contains the entry `300 ml milk`
- The capabilities report shows the default oven model and four bake
  modes

## Concepts in play

- Data sources (`oven_recipe_book`, `oven_oven`)
- Building a keyed map with a `for` expression to feed `for_each`
- `for_each` keys must be unique — count the units yourself
- `format()` verbs fill **positionally**

## Workflow

```sh
tofu test    # red → first error → fix → repeat
```

No `tofu init` (dev overrides; repo README).

## Hints

`./HINT.md` — three tiers, then try.