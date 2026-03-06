resolve_bin_root() {
  local mode
  mode="$(resolve_bin_mode "${1:-auto}")" || {
    fail "Could not resolve binary root"
    return 1
  }

  if [[ "$mode" == "system" ]]; then
    printf "/usr/local/bin"
  else
    printf "%s/.local/bin" "$HOME"
  fi
}
