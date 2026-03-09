completion_paths() {
  local shell="${1:-}"
  [[ -n "$shell" ]] || return 1

  printf "%s\n%s\n" \
    "$(completion_path "$shell" system)" \
    "$(completion_path "$shell" user)"
}
