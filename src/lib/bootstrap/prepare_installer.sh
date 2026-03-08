bootstrap_prepare_installer() {
  local version="$1"
  local template

  template=$(cat <<'BOOTSTRAP'
prepare_installer() {
  echo "Initializing installer..."
  SSI_VERSION="@VERSION@"

  # Set up tmp dir where all work is done
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  cd "$tmpdir"
  export PATH="$tmpdir:$PATH"

  # Download ssi if needed
  if ! command -v ssi >/dev/null 2>&1 || [ "$(ssi --version 2>/dev/null)" != "$SSI_VERSION" ]; then
    if command -v curl >/dev/null 2>&1; then
      curl -fSsL https://github.com/DannyBen/ssi/releases/download/v$SSI_VERSION/ssi -o ssi
    elif command -v wget >/dev/null 2>&1; then
      wget -nv -O ssi https://github.com/DannyBen/ssi/releases/download/v$SSI_VERSION/ssi
    else
      echo "Error: please install wget or curl, then try again" >&2
      exit 1
    fi
    chmod +x ssi
  fi
}
BOOTSTRAP
)

  printf "%s\n" "${template//@VERSION@/$version}"
}
