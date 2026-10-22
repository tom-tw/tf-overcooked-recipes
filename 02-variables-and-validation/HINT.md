# Hints — lesson 02 (read one tier at a time)

## Tier 1 — concept

Two ideas misfire here: a **variable default that a validation rule
rejects before any resource is even planned**, and an **instance
address that assumes more instances exist than `count` creates**.

## Tier 2 — narrowing

- Run `tofu test`: the failure happens during *validation* and names a
  variable, not a resource. Read the variable's `default` and the
  `validation` block beneath it — what pantry units does the rule
  actually allow?
- The second injury appears only in runs that go past validation: an
  error about a resource *instance index*. The salt resource uses
  `count`, so its instances are addressed by position — how many salt
  shelves does the config actually create?

## Tier 3 — words-only fix

Change the flour unit default from the imperial-sounding value to one
of the two values the validation whitelist mentions. In the
`salt_shelf` output, ask for the *first* (and only) counted instance,
not the third. Nothing else in this lesson is broken.