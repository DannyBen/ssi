startup_uninstall_zsh() {
  local name="${1:-}"
  local zsh_root="${ZDOTDIR:-$HOME}"
  local zsh_dir="$zsh_root/.zshrc.d"
  local target="$zsh_dir/$name"

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
