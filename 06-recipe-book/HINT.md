# Hints — lesson 06 (read one tier at a time)

## Tier 1 — concept

`for_each` keys must be **unique**, and `format()` fills its verbs
**positionally**. One bug crashes the plan; the other only shows up in
a failing assertion — the harder kind to spot.

## Tier 2 — narrowing

- The pantry shelves are built from a for-expression whose *key* part
  currently isn't the ingredient name. Count how many pancake
  ingredients share the same unit — `for_each` refuses duplicates.
- The shopping list compiles but fails a test asserting the text
  `300 ml milk`. The `format()` arguments are in a different order
  than the verb positions expect.

## Tier 3 — words-only fix

Key the ingredient shelves by each ingredient's *name* (each value
element already carries `.name`). In the shopping list `format()`, the
verbs are filled positionally: order the three arguments as amount,
unit, name so each entry reads like "300 ml milk".