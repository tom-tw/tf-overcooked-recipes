# Hints — lesson 01 (read one tier at a time)

## Tier 1 — concept

The kitchen config has two independent injuries: something has the
wrong *name*, and something is *structurally* open. HCL errors surface
one at a time, so the first reported error may only be the surface
wound.

## Tier 2 — narrowing

Run `tofu test` and look at the very first diagnostic: it points into
`main.tf` near the flour resource.

- One of the resource's arguments is spelled in a way the provider
  schema rejects: *unknown argument*. Compare against the provider
  docs (`oven_ingredient`: `name`, `amount`, `unit`...).
- A resource **block** somewhere near there never closes with `}`.
  HCL reports this as an error further down the file than you expect,
  usually on the *next* block's opening line.

## Tier 3 — words-only fix

In `oven_ingredient.flour`: the argument feeding the quantity is
misspelled — the provider knows `amount`, not the other word. And the
same block is missing its closing brace before `oven_tool.whisk`
begins. Fix the spelling of the quantity argument and close the block.
Nothing else is wrong in this lesson.