resolve_man_base_path() {
  local mode
  mode="$(resolve_man_mode "${1:-auto}")" || return 1

  if [[ "$mode" == "system" ]]; then
    printf "/usr/local/share/man"
  else
    printf "%s/man" "${XDG_DATA_HOME:-$HOME/.local/share}"
  fi
}
