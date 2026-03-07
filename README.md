# Simple Script Installer

![repocard](https://repocard.dannyben.com/svg/ssi.svg)

Simple Script Installer (`ssi`) is a lightweight Bash installer for binaries,
man pages, shell completions, and startup snippets. It is designed for script
authors who want a simple, semantic setup script for their users, without
re-implementing common installation decisions like target directories, root vs
non-root behavior, or handling local vs remote sources.

This README covers two usage patterns:

1. Developers (primary use case)
2. Users (manual use)

## Usage for Developers

The easiest way to use `ssi` is to provide a `setup` (and optionally an
`uninstall`) script in your repository. The script downloads `ssi` to a
temporary directory and uses its commands to install your files from your
repository (or any URL).

For example:

```bash
#!/usr/bin/env bash
set -euo pipefail

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# Download ssi to a new temp dir
cd "$tmpdir"
wget https://github.com/DannyBen/ssi/releases/download/v0.1.3/ssi
chmod +x ssi

# Use it to download and install files
./ssi install bin https://anywhere.com/your-cli
./ssi install man https://anywhere.com/docs/your-cli.1
your-cli show-completion | ./ssi install completion your-cli
./ssi install startup --shell bash https://anywhere.com/your-cli-startup.sh
```

If you wish to download the latest version of `ssi`, use this URL:

```bash
wget https://github.com/DannyBen/ssi/releases/latest/download/ssi
```

Releases are immutable.


## Usage for Users

### Install

Download the `ssi` script and put it in your `PATH`.

You can do so programmatically by running something like this:

```shell
wget https://github.com/DannyBen/ssi/blob/master/ssi
sudo install -m 755 ssi /usr/local/bin/
```

### Bash Completion for `ssi`

If you want completions for `ssi` itself, you can use `ssi` itself to download
and install its own bash completion script:

```shell
ssi install completion https://raw.githubusercontent.com/DannyBen/ssi/refs/tags/v$(ssi --version)/completions/ssi --shell bash
```

## Technical Details

`ssi` has four sets of commands:

| Command Group   | Purpose                                                                                     |
|:----------------|:--------------------------------------------------------------------------------------------|
| `install`       | Installing executables, man pages, completion scripts and startup scripts                   |
| `uninstall`     | Uninstalling executables, man pages, completion scripts and startup scripts                 |
| `test`          | Checking for the presence of executables, man pages, completion scripts and startup scripts |
| Other Utilities | Logging, Bootstrapping of `setup` scripts.                                                  |

### Install Commands

All install commands accept source in one of these forms:

- URL
- Local file
- stdin

#### `ssi install bin` Install Targets

- System target `/usr/local/bin` when running as root, when the system target is
  writable, or when `sudo` is usable.
- Otherwise user target `$HOME/.local/bin`.

#### `ssi install man` Install Targets

- System target `/usr/local/share/man` when running as root, when the system
  target is writable, when the system target parent directory is writable, or
  when `sudo` is usable.
- Otherwise user target `${XDG_DATA_HOME:-$HOME/.local/share}/man`.
- The final install path is `<target>/man<section>` where section defaults to
  `1` (for example `man1/tool.1`).

#### `ssi install completion` Install Targets

- System target is selected when running as root, when the system target is
  writable, when the system target parent directory is writable, or when `sudo`
  is usable. It varies by shell:
- System Bash: `/usr/local/share/bash-completion/completions`.
- System Zsh: `/usr/local/share/zsh/site-functions`.
- System Fish: `/usr/local/share/fish/vendor_completions.d`.
- Otherwise user target is selected, and it also varies by shell:
- User Bash: `${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions`.
- User Zsh: `${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions`.
- User Fish: `${XDG_DATA_HOME:-$HOME/.local/share}/fish/vendor_completions.d`.

#### `ssi install startup` Install Targets

- The `--shell` flag selects the target shell (default: `bash`).
- Bash installs to `~/.bashrc.d`.
- Zsh installs to `~/.zshrc.d` (or `$ZDOTDIR/.zshrc.d` when `ZDOTDIR` is set).
- Fish installs to `${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d`.
- `ssi` does not edit startup files; for Bash and Zsh, it warns if the `*.d`
  directory does not appear to be sourced.

### Uninstall Commands

All uninstall commands assume ownership over all occurrences of the
file they try to uninstall, so they attempt removal from both user
directories and system directories.

### Test Commands

Test commands check if a target is installed. By default, they check the
single path that install would choose in the current environment.

Use `--all` to check all possible install paths and report each one. The
command succeeds if any path contains the target, and warns if duplicates
are found.

The primary use cases for this command are:

- Run setup validation tests in CI
- Check if a file is installed in more than one path

### Utility Commands

- `ssi log` - use it to output messages in the same format as the internal
  `ssi` functions.
- `ssi bootstrap` - use it to output a sample scirpt that you can use for your
  `setup` script.

## Examples

| Repository                                                          | Setup Script                                                         | Uninstall Script                                                             |
|:--------------------------------------------------------------------|:---------------------------------------------------------------------|:-----------------------------------------------------------------------------|
| [DannyBen/git-changelog](https://github.com/DannyBen/git-changelog) | [setup](https://github.com/DannyBen/git-changelog/blob/master/setup) | [uninstall](https://github.com/DannyBen/git-changelog/blob/master/uninstall) |
| [DannyBen/opcode](https://github.com/DannyBen/opcode)               | [setup](https://github.com/DannyBen/opcode/blob/master/setup)        | [uninstall](https://github.com/DannyBen/opcode/blob/master/uninstall)        |
| [DannyBen/repli](https://github.com/DannyBen/repli)                 | [setup](https://github.com/DannyBen/repli/blob/master/setup)         | [uninstall](https://github.com/DannyBen/repli/blob/master/uninstall)         |
