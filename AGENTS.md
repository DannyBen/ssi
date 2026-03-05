# ssi Agent Notes

## Command Source Of Truth
- Use `op.conf` as the single source of truth for project commands.
- Preferred entry points:
- `op test` to run the test suite.
- `op generate` to regenerate the Bashly script.

## Test Command
- Run tests via `op test` (currently mapped to `bats -r test`).
- When working on a specific test file, run that file directly (it has a shebang) instead of the full suite.

## Current Test Layout
- Keep tests mirrored to source layout.
- Use one function per source file and one matching test file when practical.
- Preferred test location pattern: `test/lib/<domain>/<group>/<function>.bats`.

## Coding Conventions
- Keep resolver logic in `src/lib/resolve/...`.
- Prefer small, deterministic functions and unit tests before command integration.
- Favor readability and explicit branching over compact but opaque Bash.
- Only use a directory as a domain when its name matches the function name prefix (e.g., `resolve_*` in `src/lib/resolve/`). Otherwise, place the function at `src/lib/<name>.sh`.

## Maintenance
- Agent responsibility: update this file occasionally when project structure, commands, or test workflows change.

## Test Style Notes
- Avoid adding `teardown()` blocks unless they are functionally required.
