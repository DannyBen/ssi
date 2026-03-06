resolve_man_mode() {
  local mode="${1:-auto}"
  local system_parent

  case "$mode" in
    system | user)
      printf "%s" "$mode"
      return 0
      ;;
    auto)
      ;;
    *)
      return 1
      ;;
  esac

  if is_root; then
    printf "system"
    return 0
  fi

  if is_writable_dir "$SSI_SYSTEM_MAN_ROOT"; then
    printf "system"
    return 0
  fi

  system_parent="$(dirname "$SSI_SYSTEM_MAN_ROOT")"
  if is_writable_dir "$system_parent"; then
    printf "system"
    return 0
  fi

  if is_sudo_usable; then
    printf "system"
    return 0
  fi

  printf "user"
}
