# Terraform vs. OpenTofu — what this kitchen runs on and why

> **Overcooked edition:** this is the same primer the golden
> curriculum ships. Read it as prep or while waiting for an apply —
> the lessons lean on the OpenTofu-only features table in the finale.

This repository is **OpenTofu-first**: every lesson runs the `tofu`
binary. This document explains how OpenTofu differs from Terraform,
why the two are near-drop-in replacements for each other, and where
this repo leans on OpenTofu-only features.

> TL;DR: **If you already know Terraform, you already know OpenTofu.**
> Replace the word `terraform` with `tofu` and everything in this repo
> works the same.

## Origin story, one paragraph

OpenTofu is an open-source fork of Terraform 1.5 (renamed from
**OpenTF**). It is governed by the **Linux Foundation** under the
**MPL 2.0** license with a community-driven, vendor-neutral roadmap.
Terraform is owned by HashiCorp (now part of IBM) and is licensed under
the **BSL 1.1**, which restricts commercial competitors from building
products on its source — the change that triggered the fork in 2023.

## What is identical

| Aspect | Status |
|---|---|
| HCL syntax | Identical `.tf` files run in both tools unchanged |
| CLI workflow | `terraform init/plan/apply/destroy` ⇄ `tofu init/plan/apply/destroy` |
| State format | Same `.tfstate`; migration generally needs no state surgery |
| Providers & modules | The same provider ecosystem; each tool resolves to its own default registry (`registry.terraform.io` vs `registry.opentofu.org`) |
| Test files | `.tftest.hcl` works in both (this repo's test suites, for example) |
| Provider development | Same plugin framework; `terraform-provider-oven` serves both binaries |

Concretely from this repo: `terraform-provider-oven` was developed and
tested **against OpenTofu**, but the Go code is ordinary
terraform-plugin-framework code — `tofu plan` and a hypothetical
`terraform plan` would both drive the same provider.

## Where OpenTofu pulls ahead (and where you can try it here)

These are the OpenTofu-first features Terraform gained later, partially,
or not at all:

| Feature | OpenTofu | Terraform | Try it in this repo |
|---|---|---|---|
| **Native state encryption** (KMS, GCP KMS, PBKDF2, OpenBao) | since v1.7, built into the CLI | no built-in equivalent | `tofu` docs — orthogonal to lessons |
| **Provider `for_each`** — dynamic instances of provider configs | v1.9+, stable (requires an `alias`) | not available | **Lesson 10**: `provider "oven" { alias = "by_room" for_each = var.kitchens }` |
| **Ephemeral values/resources** — secrets stay out of state and plans | v1.10+ | arrived later/incompletely | **Lesson 10**: `ephemeral "oven_tasting_spoon" "dough"` and the acceptance tests |
| **Early variable evaluation** — variables usable in `terraform` blocks, module sources, backend config | broader support | partial | referenced in docs; not exercised by lessons |
| **`removed` blocks** | v1.8+ (destroy = false for orphaned objects) | available in v1.8+ too (parity here) | mentioned in **Lesson 08** README |

A syntax detail worth knowing when you move `provider for_each` configs
around: **OpenTofu** requires `alias` + `for_each` on the provider block
and stable, superset-safe resource selection via `setsubtract`
(lesson 10 follows the documented pattern), while Terraform 1.10 gated
the same idea behind a `configuration { provider_configuration_aliases = true }`
experimental block. Same concept, different switch.

## Where Terraform pulls ahead

Terraform's recent development prioritizes its managed **HCP Terraform**
platform:

- **Stacks** — multi-module deployment orchestration; commercial, no
  open-source OpenTofu equivalent.
- **Sentinel** policy engine — commercial, paired with HCP Terraform;
  OpenTofu users typically adopt **Open Policy Agent (OPA)** for
  policy-as-code instead.
- Terraform also has native test **mocks** (`mock_provider`), which
  OpenTofu does not implement as of this writing — one reason this
  repo's tests spin up the real (fake!) provider instead of mocking it.

## Choosing between them, for this project's audience

For *learning HCL* the answer is simple and the tools barely differ:

1. **You are learning syntax and workflows** — the two are ~identical.
   Pick the one your team runs; reading either's plans teaches you both.
2. **You value open governance and community roadmap** — OpenTofu (Linux
   Foundation, MPL 2.0).
3. **You want built-in state encryption and dynamic provider
   configurations today** — OpenTofu has them stable.
4. **You are already on HCP Terraform** with Sentinel/Stacks — stay on
   Terraform, the language you write is the same anyway.
5. **Migration is cheap** — same state, same modules, same providers:
   most migrations amount to swapping the binary and updating registry
   hostnames.

## Sources & further reading

1. **Scalr (May 2026):** [OpenTofu vs Terraform: Which One Should You Use in 2026?](https://scalr.com/learning-center/opentofu-vs-terraform) — state encryption, `for_each`, early variable evaluation, licensing.
2. **env0 (June 2026):** [OpenTofu vs Terraform: Features & Workflow Comparison](https://www.envzero.com/guides/opentofu-vs-terraform-full-comparison-for-platform-teams-2026) — drop-in replacement nature, OPA vs Sentinel.
3. **Terrateam (Dec 2025):** [OpenTofu vs. Terraform: a comparison of the IaC engines](https://terrateam.io/blog/opentofu-vs-terraform) — governance, CLI parity, early variable evaluation.
4. **OpenTofu official docs — Ephemeral values:** <https://opentofu.org/docs/language/ephemerality/> — keeping secrets out of state.
5. **OpenTofu official docs — Provider configuration:** <https://opentofu.org/docs/language/providers/configuration/> — the `alias`/`for_each` provider-instance model used in lesson 10.
6. **OpenTofu official docs — Acceptance testing the OpenTofu CLI:** <https://opentofu.org/docs/language/providers/> — the `TF_ACC_*` environment variables this repo's provider test suite uses.
7. **Medium — Surbhi (2026):** [Terraform vs OpenTofu in 2026: Should You Stay or Switch?](https://medium.com/@surbhi19/terraform-vs-opentofu-in-2026-should-you-stay-or-switch-6653dd4fa1c0) — a practitioner's stay-or-switch analysis (Medium may require a login to read).