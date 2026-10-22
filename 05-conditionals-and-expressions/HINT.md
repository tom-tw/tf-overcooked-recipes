# Hints — lesson 05 (read one tier at a time)

## Tier 1 — concept

One injury is a **misspelled data-source argument** the provider
schema rejects; the other is a **defensive expression whose armor was
stripped off** — a lookup that the tests intentionally run against a
missing key.

## Tier 2 — narrowing

- The first error is an *"argument not expected here"* on a data
  block: the argument name for the recipe to look up is one letter off
  from `recipe_name`.
- The second failure is a runtime *"key does not identify an element"*
  on the flavor lookup. The original design had the lookup wrapped so
  a failed lookup would fall back to a sensible default — compare this
  local against the lesson's prose about catchable runtime errors.

## Tier 3 — words-only fix

Fix the data block's argument spelling (it should read `recipe_name`).
Wrap the flavor lookup expression so that a failed map lookup yields
the house fallback string instead of erroring — the same local also
uppercases its result; keep that.