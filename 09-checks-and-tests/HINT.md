# Hints — lesson 09 (read one tier at a time)

## Tier 1 — concept

This lesson overcooked two safety systems: the **chaos dial** is
cranked so failures stop being about your code, and a **lifecycle
postcondition** expresses the opposite of its intention.

## Tier 2 — narrowing

- Read the provider config first: `chaos_level` is not zero. The
  messages you were seeing ("gas ran out", "the cat sat...") come from
  that dial, not from your fixes. But note the attempt cap: even at
  maximum chaos the kitchen forgives you by the third identical apply.
- The postcondition lives inside `oven_bake.saturday_bread`. Its
  condition says which loaves the inspector *accepts*. A healthy
  220 °C / 45 min loaf comes out "well-done" — is "well-done"
  currently accepted?

## Tier 3 — words-only fix

Turn the chaos dial back down to zero in the provider block. In the
postcondition, the inspector should reject *only* charcoal: the
condition must pass for every doneness except the burnt one. When
fixed, both test runs pass — including the one expecting the resource
to report a failure for a deliberately burnt bake.