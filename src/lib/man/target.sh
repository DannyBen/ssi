man_target() {
  local raw_name="${1:-}"
  local base section filename

  if [[ -z "$raw_name" ]]; then
    fail "Missing man page name"
    return 1
  fi

  base="$(basename "$raw_name")"
  if [[ "$base" =~ \.([A-Za-z0-9]+)$ ]]; then
    section="${BASH_REMATCH[1]}"
    filename="$base"
  else
    section="1"
    filename="${base}.1"
  fi

  printf "%s:%s" "$section" "$filename"
}
