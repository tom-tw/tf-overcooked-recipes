# Hints — lesson 07 (read one tier at a time)

## Tier 1 — concept

A module call has three moving parts: **where it comes from**,
**which instances exist**, and **its required inputs**. Two of the
three were sabotaged.

## Tier 2 — narrowing

- The first error appears the moment tofu looks *inside* the module
  path. Compare the `source` string against the directory that
  actually exists under this lesson (`ls`; count the letters in
  "modules").
- The second error is emitted *from the module*: a `required` input
  is being set nowhere. The module `modules/cookies` demands a batch
  label; check which inputs the module call supplies.

## Tier 3 — words-only fix

Fix the `source` path spelling. Then restore the missing input: for
each flavor module instance, the batch name is exactly the flavor
key — pass it through with the `each` object. The servings and
temperature are already wired; don't touch them.

## Workflow note

This lesson also needs the one-time `tofu init` first (see the lesson
README): the loud resolver error is the known dev-override behavior,
and the local module installs anyway.