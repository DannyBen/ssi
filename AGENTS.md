# ssi Agent Notes

## Command Source Of Truth
- Use `op.conf` as the single source of truth for project commands.
- Preferred entry points:
- `op test` to run the test suite.
- `op generate` to regenerate the Bashly script.

## Project Intent (Condensed)
- `ssi` is a lightweight Bash installer for binaries, man pages, completions, and startup snippets.
- Supports installation from URL, local file, or stdin.
- Should work for root vs. non-root targets with standard Linux paths.
- Uninstall is stateless; no local manifest/database.

## Test Command
- Run tests via `op test` (currently mapped to `bats -r test`).
- When working on a specific test file, run that file directly (it has a shebang) instead of the full suite.
- For CLI integration tests, run the generated `./ssi` binary with temp `HOME` and PATH stubs.
- Whenever a test is updated, run that test (unless the user already ran it).

## Current Test Layout
- The test directory structure must always mirror `src`.
- Use one function per source file and one matching test file when practical.
- Preferred test location pattern: mirror the source path (e.g., `src/lib/resolve/bin_mode.sh` -> `test/lib/resolve/bin_mode.bats`).
- Use `test/fixtures/` for reusable stub executables and fixtures.

## Coding Conventions
- Keep resolver logic in `src/lib/resolve/...`.
- When a domain has its own directory (e.g., `resolve/`), filenames inside it omit the domain prefix (e.g., `resolve/bin_mode.sh` for `resolve_bin_mode()`).
- Use `log info` for user-facing success/info output and `log warn` for warnings so output styling stays consistent. `fail` remains `log error` + return 1.
- Prefer small, deterministic functions and unit tests before command integration.
- Favor readability and explicit branching over compact but opaque Bash.
- Do not set default values for args in command handlers; rely on Bashly defaults.
- Do not add manual "required arg" validation in command handlers; use Bashly `required: true`.
- In tests, prefer sourcing real libs; stub only when required by the test scenario.
- Only use a directory as a domain when its name matches the function name prefix (e.g., `resolve_*` in `src/lib/resolve/`). Otherwise, place the function at `src/lib/<name>.sh`.
- For command tests that assert CLI output, set `NO_COLOR=1` for deterministic output.

## Maintenance
- Agent responsibility: update this file occasionally when project structure, commands, or test workflows change.
- Do not read the generated `ssi` file; it is large and mirrors source files elsewhere.
- Before moving from discussion/planning to implementation (code changes, generation, or running tests), get explicit user approval.

## Test Style Notes
- Avoid adding `teardown()` blocks unless they are functionally required.
