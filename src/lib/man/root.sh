man_root() {
  local mode
  mode="$(man_mode "${1:-auto}")" || return 1

  if [[ "$mode" == "system" ]]; then
    printf "%s" "$SSI_SYSTEM_MAN_ROOT"
  else
    printf "%s" "$SSI_USER_MAN_ROOT"
  fi
}
