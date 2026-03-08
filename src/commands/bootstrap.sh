script_version="$version"
template=$(cat <<'BOOTSTRAP'
#!/usr/bin/env bash
set -euo pipefail

# === Setup SSI ===

echo "Initializing installer..."

# Set up tmp dir where all work is done
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"
export PATH="$tmpdir:$PATH"

# Download ssi if needed
if ! command -v ssi >/dev/null 2>&1 || [ "$(ssi --version 2>/dev/null)" != "@VERSION@" ]; then
  if command -v curl >/dev/null 2>&1; then
    curl -fSsL https://github.com/DannyBen/ssi/releases/download/v@VERSION@/ssi -o ssi
  elif command -v wget >/dev/null 2>&1; then
    wget -nv -O ssi https://github.com/DannyBen/ssi/releases/download/v@VERSION@/ssi
  else
    echo "Error: please install wget or curl, then try again" >&2
    exit 1
  fi
  chmod +x ssi
fi

# === Run ===

# Example installation steps:
# ssi log info "Installing <tool>"
# ssi install bin <url>
# ssi install man <url>
# ssi log info "<tool> --version : $(<tool> --version)"
BOOTSTRAP
)
printf "%s\n" "${template//@VERSION@/$script_version}"
