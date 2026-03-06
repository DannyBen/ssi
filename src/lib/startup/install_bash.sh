startup_install_bash() {
  local source="${1:-}"
  local name="${2:-}"
  local bash_rc="$HOME/.bashrc"
  local bash_dir="$HOME/.bashrc.d"

  if [[ ! -f "$bash_rc" && ! -d "$bash_dir" ]]; then
    return 2
  fi

  create_dir "$bash_dir" || return 1
  install_file "$source" "$bash_dir/$name" 644 || return 1

  if [[ -f "$bash_rc" ]] && ! grep -Fq "$bash_dir" "$bash_rc"; then
    log warn "Bash startup configuration incomplete; add this to $bash_rc:"
    log warn 'for f in ~/.bashrc.d/*; do . "$f"; done'
  elif [[ ! -f "$bash_rc" ]]; then
    log warn "file not found: $bash_rc; ensure $bash_dir is sourced"
  fi

  return 0
}
