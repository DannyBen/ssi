startup_install_zsh() {
  local source="${1:-}"
  local name="${2:-}"
  local zsh_root="${ZDOTDIR:-$HOME}"
  local zsh_rc="$zsh_root/.zshrc"
  local zsh_dir="$zsh_root/.zshrc.d"

  if [[ ! -f "$zsh_rc" && ! -d "$zsh_dir" ]]; then
    return 2
  fi

  create_dir "$zsh_dir" || return 1
  install_file "$source" "$zsh_dir/$name" 644 || return 1

  if [[ -f "$zsh_rc" ]] && ! grep -Fq "$zsh_dir" "$zsh_rc"; then
    log warn "Zsh startup configuration incomplete; add this to $zsh_rc:"
    log warn "for f in ~/.zshrc.d/*; do . \"\$f\"; done"
  elif [[ ! -f "$zsh_rc" ]]; then
    log warn "file not found: $zsh_rc; ensure $zsh_dir is sourced"
  fi

  return 0
}
