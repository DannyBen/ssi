# Simple Script Installer

Simple Script Installer (`ssi`) is a lightweight Bash installer for binaries,
man pages, and shell completions. It is designed for script authors who want a
simple, semantic setup script for their users, without re-implementing common
installation decisions like target directories, root vs non-root behavior, or
handling local vs remote sources.

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

cd "$tmpdir"
wget https://github.com/DannyBen/ssi/blob/master/ssi
chmod +x ssi

./ssi bin https://github.com/You/YourRepo/blob/master/your-cli
./ssi man https://github.com/You/YourRepo/blob/master/docs/your-cli.1
your-cli show-completion | ./ssi completion your-cli
```


## Usage for Users

### Install

Download the `ssi` script and put it in your `PATH`.

You can do so programmatically by running something like this:

```shell
wget https://github.com/DannyBen/ssi/blob/master/ssi
sudo install -m 755 ssi /usr/local/bin/
```
