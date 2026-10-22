# Hints — lesson 10 (read one tier at a time)

## Tier 1 — concept

Three advanced features, three misfires: a **provider instance
reference without its alias**, a **dynamic block content that reads
attributes the source objects don't have**, and an **ephemeral value
trying to escape into an output**, which the language forbids.

## Tier 2 — narrowing

- The provider blocks: one has `alias = "by_room"` with `for_each`;
  resources select instances as `alias-name[each.key]`. One resource
  forgot the alias segment of the reference — the error text says the
  provider assignment "requires an alias".
- Inside `dynamic "steps"`, the `content` block maps the iteration
  object (`steps.value`) onto the nested attributes. The for
  expression building the iterator produces keys `order` and
  `description` — compare with what `content` reads.
- The last error is explicit about ephemeral values: they may only
  flow to other ephemeral resources (and write-only attributes), never
  to outputs. The offending output block announces exactly what it
  leaks.

## Tier 3 — words-only fix

Point the regional flour resource at the *aliased* provider instance
so each room gets its own kitchen instance. In the dynamic content,
read the attributes the iterator object actually carries. Remove the
output block that leaks the ephemeral verdict entirely — the spoon's
result is consumed during the apply and stays out of state.