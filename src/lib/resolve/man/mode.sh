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
