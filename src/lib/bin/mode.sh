bin_mode() {
  local mode="${1:-auto}"

  case "$mode" in
    system | user)
      printf "%s" "$mode"
      return 0
      ;;
    auto)
      ;;
    *)
      fail "Could not resolve install mode"
      return 1
      ;;
  esac

  if is_root; then
    printf "system"
    return 0
  fi

  if is_writable_dir "$SSI_SYSTEM_BIN_ROOT"; then
    printf "system"
    return 0
  fi

  if is_sudo_usable; then
    printf "system"
    return 0
  fi

  printf "user"
}
