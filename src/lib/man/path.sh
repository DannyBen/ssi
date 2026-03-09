man_path() {
  local section="${1:-1}"
  local mode="${2:-auto}"
  local root

  root="$(man_root "$mode")" || return 1
  printf "%s/man%s" "$root" "$section"
}
