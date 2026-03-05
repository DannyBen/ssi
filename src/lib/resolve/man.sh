resolve_man_mode() {
  local mode="${1:-auto}"

  case "$mode" in
    system | user)
      printf "%s" "$mode"
      return 0
      ;;
    auto)
      ;;
    *)
      printf "invalid mode: %s\n" "$mode" >&2
      return 1
      ;;
  esac

  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    printf "system"
    return 0
  fi

  if [[ -d "/usr/local/share/man" && -w "/usr/local/share/man" ]]; then
    printf "system"
    return 0
  fi

  if [[ -d "/usr/local/share" && -w "/usr/local/share" ]]; then
    printf "system"
    return 0
  fi

  if command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
    printf "system"
    return 0
  fi

  printf "user"
}

resolve_man_base_path() {
  local mode
  mode="$(resolve_man_mode "${1:-auto}")" || return 1

  if [[ "$mode" == "system" ]]; then
    printf "/usr/local/share/man"
  else
    printf "%s/man" "${XDG_DATA_HOME:-$HOME/.local/share}"
  fi
}

resolve_man_path() {
  local section="${1:-1}"
  local mode="${2:-auto}"
  local base_path

  base_path="$(resolve_man_base_path "$mode")" || return 1
  printf "%s/man%s" "$base_path" "$section"
}
