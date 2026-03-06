startup_install_fish() {
  local source="${1:-}"
  local name="${2:-}"
  local fish_root="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
  local fish_rc="$fish_root/config.fish"
  local fish_dir="$fish_root/conf.d"

  if [[ ! -f "$fish_rc" && ! -d "$fish_dir" ]]; then
    return 2
  fi

  create_dir "$fish_dir" || return 1
  install_file "$source" "$fish_dir/$name" 644 || return 1
}
