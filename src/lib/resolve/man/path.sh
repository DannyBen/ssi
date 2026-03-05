resolve_man_path() {
  local section="${1:-1}"
  local mode="${2:-auto}"
  local base_path

  base_path="$(resolve_man_base_path "$mode")" || return 1
  printf "%s/man%s" "$base_path" "$section"
}
