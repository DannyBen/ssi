resolve_man_base_path() {
  local mode
  mode="$(resolve_man_mode "${1:-auto}")" || return 1

  if [[ "$mode" == "system" ]]; then
    printf "%s" "$SSI_SYSTEM_MAN_ROOT"
  else
    printf "%s" "$SSI_USER_MAN_ROOT"
  fi
}
