startup_uninstall() {
  local name="${1:-}"
  local shell="${2:-}"
  local strict="${3:-}"
  local startup_dir target missing_message

  startup_dir="$(startup_path "$shell")" || {
    fail "Unknown shell: $shell"
    return 1
  }

  target="${startup_dir}/${name}"
  missing_message="$(startup__missing_message "$shell")" || return 1

  if [[ -z "$name" ]]; then
    fail "Missing startup name"
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    if [[ -n "$strict" ]]; then
      fail "$missing_message"
      return 1
    fi

    log info "Skip: $missing_message"
    return 0
  fi

  remove_file "$target" || return 1
  log info "Removed startup file: $target"
}
