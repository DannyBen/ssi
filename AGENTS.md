# ssi Agent Notes

## Command Source Of Truth
- Use `op.conf` as the single source of truth for project commands.
- Preferred entry points:
- `op test` to run the test suite.
- `op generate` to regenerate the Bashly script.

## Project Intent (Condensed)
- `ssi` is a lightweight Bash installer for binaries, man pages, and completions.
- Supports installation from URL, local file, or stdin.
- Should work for root vs. non-root targets with standard Linux paths.
- Uninstall is stateless; no local manifest/database.

## Test Command
- Run tests via `op test` (currently mapped to `bats -r test`).
- When working on a specific test file, run that file directly (it has a shebang) instead of the full suite.
- For CLI integration tests, run the generated `./ssi` binary with temp `HOME` and PATH stubs.

## Current Test Layout
- Keep tests mirrored to source layout.
- Use one function per source file and one matching test file when practical.
- Preferred test location pattern: `test/lib/<domain>/<group>/<function>.bats`.
- Use `test/fixtures/` for reusable stub executables and fixtures.

## Coding Conventions
- Keep resolver logic in `src/lib/resolve/...`.
- Prefer small, deterministic functions and unit tests before command integration.
- Favor readability and explicit branching over compact but opaque Bash.
- Only use a directory as a domain when its name matches the function name prefix (e.g., `resolve_*` in `src/lib/resolve/`). Otherwise, place the function at `src/lib/<name>.sh`.
- For command tests that assert CLI output, set `NO_COLOR=1` for deterministic output.

## Maintenance
- Agent responsibility: update this file occasionally when project structure, commands, or test workflows change.

## Test Style Notes
- Avoid adding `teardown()` blocks unless they are functionally required.
