startup_uninstall_bash() {
  local name="${1:-}"
  local bash_dir="$HOME/.bashrc.d"
  local target="$bash_dir/$name"

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
