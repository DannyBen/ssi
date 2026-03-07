startup_install_zsh() {
  local source="${1:-}"
  local name="${2:-}"
  local strict="${3:-}"
  local zsh_root="${ZDOTDIR:-$HOME}"
  local zsh_rc="$zsh_root/.zshrc"
  local zsh_dir="$zsh_root/.zshrc.d"
  local target=""

  if [[ ! -f "$zsh_rc" && ! -d "$zsh_dir" ]]; then
    if [[ -n "$strict" ]]; then
      fail "Zsh startup file not found"
      return 1
    fi

    log info "Skip: Zsh startup file not found"
    return 0
  fi

  create_dir "$zsh_dir" || return 1
  target="$zsh_dir/$name"
  install_file "$source" "$target" 644 || return 1
  log info "Installed startup file: $target"

  if [[ -f "$zsh_rc" ]] && ! grep -Fq ".zshrc.d" "$zsh_rc"; then
    log warn "Zsh startup configuration incomplete; add this to $zsh_rc:"
    log warn "for f in ~/.zshrc.d/*; do . \"\$f\"; done"
  elif [[ ! -f "$zsh_rc" ]]; then
    log warn "Zsh startup file (~/.zshrc) not found; ensure $zsh_dir is sourced"
  fi

  return 0
}
