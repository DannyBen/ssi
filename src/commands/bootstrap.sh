cat <<'BOOTSTRAP'
#!/usr/bin/env bash
set -euo pipefail

# === Setup SSI ===

echo "Initializing installer..."
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"

if command -v wget >/dev/null 2>&1; then
  wget -nv -O ssi https://github.com/DannyBen/ssi/releases/latest/download/ssi
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL https://github.com/DannyBen/ssi/releases/latest/download/ssi -o ssi
else
  echo "Error: please install wget or curl, then try again" >&2
  exit 1
fi
chmod +x ssi

export PATH="$tmpdir:$PATH"

# === Install ===

# Example installation steps:
# ssi log info "Installing <tool>"
# ssi bin <url>
# ssi man <url>
# <tool> --completions | ssi completion --shell bash --name <tool> -
# ssi log info "<tool> --version : $(<tool> --version)"
BOOTSTRAP
