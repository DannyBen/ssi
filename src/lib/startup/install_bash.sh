startup_install_bash() {
  local source="${1:-}"
  local name="${2:-}"
  local strict="${3:-}"
  local bash_rc="$HOME/.bashrc"
  local bash_dir="$HOME/.bashrc.d"
  local target=""

  if [[ ! -f "$bash_rc" && ! -d "$bash_dir" ]]; then
    if [[ -n "$strict" ]]; then
      fail "Bash startup file not found"
      return 1
    fi

    log info "Skip: Bash startup file not found"
    return 0
  fi

  create_dir "$bash_dir" || return 1
  target="$bash_dir/$name"
  install_file "$source" "$target" 644 || return 1
  log info "Installed startup file: $target"

  if [[ -f "$bash_rc" ]] && ! grep -Fq ".bashrc.d" "$bash_rc"; then
    log warn "Bash startup configuration incomplete; add this to $bash_rc:"
    log warn "for f in ~/.bashrc.d/*; do . \"\$f\"; done"
  elif [[ ! -f "$bash_rc" ]]; then
    log warn "Bash startup file (~/.bashrc) not found; ensure $bash_dir is sourced"
  fi

  return 0
}
