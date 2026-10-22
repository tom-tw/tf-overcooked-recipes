# Hints — lesson 04 (read one tier at a time)

## Tier 1 — concept

Counted resources start at **zero**, humans start at **one**, and
**splat** (`[*]`) only exists when you ask for it. Two small
incisions, one lesson.

## Tier 2 — narrowing

- One test expects a tray named "batch 01" for `count.index = 0`. Look
  at what gets added to `count.index` inside `format()` — the tray
  names currently begin at a suspiciously early number.
- The other injury is an attribute lookup on a *collection value* that
  isn't valid in HCL. `oven_bake.cookies` is a sequence of instances;
  extracting `doneness` from every element needs the operator that
  means "map each instance to its attribute".

## Tier 3 — words-only fix

In the tray `name`, add one to `count.index` before formatting, so the
first tray is `cookie-batch-01`, not batch zero. In the
`all_doneness` local, mark the attribute extraction with a splat on
the resource collection (the operator sits between the resource name
and the attribute name, like `.doneness`'s hat).