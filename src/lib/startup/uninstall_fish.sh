startup_uninstall_fish() {
  local name="${1:-}"
  local fish_root="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
  local fish_dir="$fish_root/conf.d"
  local target="$fish_dir/$name"

  if [[ -z "$name" ]]; then
    fail "Missing startup name"
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    return 2
  fi

  remove_file "$target" || return 1
  log info "Removed: $target"
  return 0
}
