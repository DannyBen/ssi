startup_uninstall_bash() {
  local name="${1:-}"
  local strict="${2:-}"
  local bash_dir="$HOME/.bashrc.d"
  local target="$bash_dir/$name"

  if [[ -z "$name" ]]; then
    fail "Missing startup name"
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    if [[ -n "$strict" ]]; then
      fail "Bash startup file not found"
      return 1
    fi

    log info "Skip: Bash startup file not found"
    return 0
  fi

  remove_file "$target" || return 1
  log info "Removed startup file: $target"
  return 0
}
