# Hints — lesson 03 (read one tier at a time)

## Tier 1 — concept

Local expressions break in two flavors here: a **template directive
that never closes**, and a **provider function called with fewer
arguments than its definition requires**. Both are caught before any
resource is planned.

## Tier 2 — narrowing

- The first error mentions a *missing directive terminator*. The
  string templates in this lesson use `%{ if }`, `%{ else }` — every
  `%{ if }` you open must be matched by a specific closing directive.
  Look closely at the last conditional template's tail.
- The second error names a function and a *want/got count of
  arguments*. Three provider functions are called in `locals`; one of
  them converts between temperature units — how many arguments does a
  value + source-unit + target-unit conversion logically need?

## Tier 3 — words-only fix

Close the conditional template directive that is dangling open (the
`else` branch's sentence currently ends the string — add the missing
closing directive after it). And give the temperature conversion its
full argument trio: value, from-unit, to-unit — the third argument is
the target unit currently omitted.