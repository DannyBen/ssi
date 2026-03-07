startup_uninstall_zsh() {
  local name="${1:-}"
  local strict="${2:-}"
  local zsh_root="${ZDOTDIR:-$HOME}"
  local zsh_dir="$zsh_root/.zshrc.d"
  local target="$zsh_dir/$name"

  if [[ -z "$name" ]]; then
    fail "Missing startup name"
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    if [[ -n "$strict" ]]; then
      fail "Zsh startup file not found"
      return 1
    fi

    log info "Skip: Zsh startup file not found"
    return 0
  fi

  remove_file "$target" || return 1
  log info "Removed startup file: $target"
  return 0
}
