# tf-overcooked-recipes — learn OpenTofu by fixing broken kitchens

Rustlings-for-OpenTofu: **ten overcooked lessons**, each with a
deliberately broken config and a test suite that defines what correct
looks like. Fix lesson by lesson until the whole kitchen is golden.

```
$ cd 01-hello-kitchen && tofu test
Error: Unclosed configuration block
    on main.tf line 16, in resource "oven_ingredient" "flour":
    16: resource "oven_ingredient" "flour" {
$ ...learn, fix, repeat...
$ ../grade.sh
[✓ golden]  01-hello-kitchen
[✗ still overcooked]  02-variables-and-validation   ← fix next
10 lessons: 1/10 golden
```

## For learners

### How to play

```sh
./setup.sh               # builds the local provider + registers dev overrides
cd 01-hello-kitchen
tofu test                # red
cat HINT.md              # (optionally) tier 1 only — then try again
# edit main.tf
tofu test                # repeat until green
```

- The **tests are the specification**: each lesson's `tests/*.tftest.hcl`
  describes the expected outcome; your config must satisfy it.
- `HINT.md` has three tiers — concept, narrowing, words-only fix. Peek
  one tier at a time; tier 3 explains the fix in prose, never in code.
- **Never run `tofu init` here.** The provider is loaded via dev
  overrides at plan/apply time; current OpenTofu refuses
  init-with-overrides on purpose. (Exception: lesson 07 needs a one-time
  noisy `tofu init` for its local module — its README explains.)
- Lessons stay `chaos_level = 0` except where the lesson *teaches you
  to notice* it isn't.

### Rules of the dojo

1. Read the FIRST diagnostic only; fix; repeat.
2. `TF_LOG=trace tofu test` makes OpenTofu narrate its own decisions.
3. If errors mention gas, cats or elves — that's the chaos engine, not
   you. Ask yourself which dial is cranked.

### Prerequisites

- [OpenTofu](https://opentofu.org/docs/intro/install/) ≥ 1.10
- [Go](https://go.dev/dl/) (to build the local provider; `./setup.sh`
  handles the rest)

## For instructors

- **Grading**: clone a student's copy, run `./grade.sh` — a Rustlings-style
  scoreboard (`[✗ still overcooked]` per lesson, exit code 1 while any
  lesson fails). `./grade.sh 05` grades a single lesson.
- **Answer key**: the golden sibling repository holds the fixed lessons
  and their long-form explanations. Keep it out of student reach; the
  overcooked repo never references it.
- Every lesson is verified **red-before / green-after** with its planted
  defects; planted bugs per lesson: 01: 2, 02: 2, 03: 2, 04: 2, 05: 2,
  06: 2, 07: 2, 08: 2, 09: 2, 10: 3.
- `make test-all` is the golden-repo convenience; here `tofu test` per
  lesson is the unit of progress.

## Repo map

```
10X-<name>/          one overcooked lesson
  main.tf            broken config (your playground)
  tests/*.tftest.hcl the specification (pass = done)
  README.md          task description + concepts in play
  HINT.md            staged hints (tier 1 → 3, no code)
grade.sh             instructor scoreboard
setup.sh             provider build + dev override registration
TF-vs-TOFU.md        Terraform vs OpenTofu primer
```

See [TF-vs-TOFU.md](TF-vs-TOFU.md) for why this curriculum is
`tofu`-first.