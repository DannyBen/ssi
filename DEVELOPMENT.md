# Development Guide

## Purpose
- This file defines the project's source layout and coding policies.
- `README.md` is user-facing. This file is contributor-facing.
- If this file and `AGENTS.md` overlap, this file is the source of truth for
  architecture and coding conventions.

## Source Layout
- Organize `src/lib` into two categories:
- `src/lib/core/` for shared libraries and cross-cutting helpers.
- `src/lib/<domain>/` for domain-specific logic such as `bin/`, `man/`,
  `completion/`, `startup/`, and `bootstrap/`.
- The test tree must mirror the source tree under `test/`.

## Core Vs Domain Code
- `src/lib/core/` may contain library-style files with multiple tightly related
  functions.
- Typical examples include logging, colors, filesystem helpers, source-fetching
  helpers, and environment checks.
- Domain directories should default to one file per public function.
- Do not force unrelated helpers into a domain directory just to avoid `core/`.

## Naming Rules
- In domain directories, filenames omit the domain prefix and match the function
  suffix.
- Example: `src/lib/man/path.sh` defines `man_path()`.
- Use consistent names across domains where the concept is the same.
- Prefer names like `*_mode`, `*_root`, `*_path`, and `*_paths`.
- Keep public function names domain-prefixed.

## Public And Private Helpers
- Default to public, domain-prefixed helper functions in their own files.
- When a helper is intentionally private to a domain, prefix it with a double
  underscore after the domain.
- Example: `src/lib/man/_roots.sh` defines `man__roots()`.
- Do not use nested functions as a substitute for private helpers.

## Command File Rules
- Command files are thin adapters.
- A command file should read Bashly inputs, perform minimal normalization if
  needed, and delegate to helpers.
- Command files should not hold domain logic, resolver logic, or non-trivial
  branching.
- Command files must not define nested functions.

## Function Design
- Prefer small, deterministic functions.
- Keep domain concepts explicit even when some logic is shared internally.
- A function should exist only if it defines a stable domain concept, hides
  meaningful branching, centralizes repeated logic, or improves testability.
- If a function is only pass-through ceremony, inline it or merge it.

## Tests
- The test directory must mirror `src`.
- Prefer one function per source file and one matching test file when
  practical.
- Prefer sourcing real libs in tests; stub only when required by the scenario.
- Use `test/fixtures/` for reusable stub executables and fixtures.
- For command tests that assert CLI output, set `NO_COLOR=1`.

## Refactor Process
- First agree on names, namespaces, and target paths.
- Then do a mechanical rename and move pass with no behavior changes.
- Move matching tests in the same pass.
- After the namespace is stable, review that namespace for redundant helpers,
  merge opportunities, and removals.
- Run the affected tests after each step.

## Size Reduction Goal
- Moving and renaming code improves navigation but usually does not shrink the
  generated `ssi` script by itself.
- Size reduction should come from deleting wrappers, consolidating duplicated
  control flow, and replacing shell-specific repetition with shared helpers
  where that keeps the code clear.
