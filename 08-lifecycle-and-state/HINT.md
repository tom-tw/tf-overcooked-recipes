# Hints — lesson 08 (read one tier at a time)

## Tier 1 — concept

State surgery has two sharp edges: a `moved` block must point **from
the old address to the new one**, and provider **aliases** are exact
identifiers — tofu will not fuzzy-match them.

## Tier 2 — narrowing

- The move block's direction is inverted: the `to` side must be an
  address that *actually exists in the configuration*, while the
  `from` side names the address that no longer does. Read the error:
  it complains about which side being "not declared".
- The other error is an *invalid provider configuration reference*:
  one alias reference lost its underscore. Compare the reference in
  the beach data source with the `alias = ...` line in the second
  provider block above it.

## Tier 3 — words-only fix

Swap the two addresses in the `moved` block (old address first, new
address second). Fix the data source's provider reference to match
the alias spelled in the provider block. After both fixes, applying
this lesson reuses existing state instead of destroying anything.