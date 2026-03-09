source_target_name() {
  local source_input="${1:-}"
  local name=""

  if [[ -z "$source_input" ]]; then
    fail "Missing source input"
    return 1
  fi

  if [[ "$source_input" == "-" ]]; then
    printf ""
    return 0
  fi

  if [[ "$source_input" =~ ^https?:// ]]; then
    if [[ "$source_input" =~ ^https?://[^/]+/?$ ]]; then
      printf ""
      return 0
    fi
    name="${source_input##*/}"
    name="${name%%\?*}"
    printf "%s" "$name"
    return 0
  fi

  printf "%s" "$(basename "$source_input")"
}
