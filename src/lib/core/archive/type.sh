archive_type() {
  local source_input="${1:-}"
  local target_name

  if [[ -z "$source_input" ]]; then
    fail "Missing archive source"
    return 1
  fi

  target_name="$(source_target_name "$source_input" 2>/dev/null || true)"
  if [[ -z "$target_name" && "$source_input" != "-" ]]; then
    target_name="$(basename "$source_input")"
  fi

  case "$target_name" in
    *.tar.gz | *.tgz)
      printf "tar.gz"
      return 0
      ;;
  esac

  fail "Unsupported archive format: $source_input"
  return 1
}
