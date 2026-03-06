resolve_bin_root() {
  local mode
  mode="$(resolve_bin_mode "${1:-auto}")" || {
    fail "Could not resolve binary root"
    return 1
  }

  if [[ "$mode" == "system" ]]; then
    printf "%s" "$SSI_SYSTEM_BIN_ROOT"
  else
    printf "%s" "$SSI_USER_BIN_ROOT"
  fi
}
