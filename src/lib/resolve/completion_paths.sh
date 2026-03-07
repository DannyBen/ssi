resolve_completion_paths() {
  local shell="${1:-}"
  [[ -n "$shell" ]] || return 1

  printf "%s\n%s\n" \
    "$(resolve_completion_base_path "$shell" system)" \
    "$(resolve_completion_base_path "$shell" user)"
}
