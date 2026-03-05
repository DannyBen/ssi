# Project Specification: Simple Script Installer (ssi)

## Overview
`ssi` is a lightweight, dependency-free (pure Bash) micro-installer designed to standardize the installation and uninstallation of standalone shell scripts, man pages, and completions across different Linux distributions and permissions levels (root vs. non-root).

## Core Principles
1. **Zero Footprint:** The tool is bootstrapped via a remote script into `/tmp`, used, and then automatically cleaned up via `trap`.
2. **Stateless Uninstallation:** No local manifest/database. `ssi` knows the standard Linux filesystem paths and "hunts" for files based on the project name.
3. **Piped Input Support:** Supports installation from URLs, local files, or STDIN (for generated completions).
4. **Normalization:** Abstracts away the difference between `/usr/local/bin` and `~/.local/bin`.

## Architecture & Commands (Bashly based)

### 1. The Bootstrapper (`ssi.sh/bootstrap`)
```bash
#!/usr/bin/env bash
# Downloads the bashly-generated ssi binary to a temp location
export SSI_BIN=$(mktemp /tmp/ssi.XXXXXX)
curl -sSL [https://ssi.sh/ssi-binary](https://ssi.sh/ssi-binary) -o "$SSI_BIN"
chmod +x "$SSI_BIN"
alias ssi="$SSI_BIN"
trap "rm -f $SSI_BIN" EXIT

```

### 2. Implementation in a Repository (e.g., `dannyben/rush`)

**setup script:**

```bash
#!/usr/bin/env bash
eval "$(curl -sSL [https://ssi.sh/bootstrap](https://ssi.sh/bootstrap))"

SSI_ROOT="[https://raw.githubusercontent.com/dannyben/rush/main](https://raw.githubusercontent.com/dannyben/rush/main)"

# Install binary
ssi bin "$SSI_ROOT/rush"

# Install man pages
ssi man "$SSI_ROOT/docs/rush.1"

# Install completions (via Pipe/Stdin for dynamic generation)
echo "eval \$(rush completions)" | ssi completion --shell bash --name rush

```

**uninstall script:**

```bash
#!/usr/bin/env bash
eval "$(curl -sSL [https://ssi.sh/bootstrap](https://ssi.sh/bootstrap))"

ssi rm bin rush
ssi rm man rush.1
ssi rm completion rush

```

## Technical Requirements for `ssi` CLI (The Agent's Task)

### Command: `ssi bin <SOURCE>`

* Detect `$EUID`.
* If `0`: target `/usr/local/bin`.
* Else: target `~/.local/bin` (ensure directory exists).
* Support URL (curl/wget) or local file path.

### Command: `ssi man <SOURCE> [--section <N>]`

* Handle paths like `/usr/local/share/man/man1`.
* Automatically handle `.gz` compression if the system requires it.

### Command: `ssi completion <SOURCE> --shell <SHELL> --name <NAME>`

* Support `bash`, `zsh`, `fish`.
* If `SOURCE` is `-`, read from `stdin`.
* Place in appropriate `site-functions` or `completions` directory based on root/user status.

### Command: `ssi rm <TYPE> <NAME>`

* Search for the file in both system and user-level directories.
* Perform a "smart delete" (e.g., if removing `rush.1`, also check for `rush.1.gz`).

## Next Steps for the Agent

1. Initialize a new `bashly` project.
2. Define the `bashly.yaml` with the subcommands: `bin`, `man`, `completion`, and `rm`.
3. Implement the logic for directory detection (Path Discovery Logic).
