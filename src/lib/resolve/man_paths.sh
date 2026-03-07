resolve_man_paths() {
  local section="${1:-1}"

  printf "%s\n%s\n" \
    "$(resolve_man_path "$section" system)" \
    "$(resolve_man_path "$section" user)"
}
