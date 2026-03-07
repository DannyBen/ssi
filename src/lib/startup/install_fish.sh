startup_install_fish() {
  local source="${1:-}"
  local name="${2:-}"
  local strict="${3:-}"
  local fish_root="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
  local fish_rc="$fish_root/config.fish"
  local fish_dir="$fish_root/conf.d"
  local target=""

  if [[ ! -f "$fish_rc" && ! -d "$fish_dir" ]]; then
    if [[ -n "$strict" ]]; then
      fail "Fish startup file not found"
      return 1
    fi

    log info "Skip: Fish startup file not found"
    return 0
  fi

  create_dir "$fish_dir" || return 1
  target="$fish_dir/$name"
  install_file "$source" "$target" 644 || return 1
  log info "Installed startup file: $target"
}
