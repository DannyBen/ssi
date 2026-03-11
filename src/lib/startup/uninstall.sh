startup_uninstall() {
  local name="${1:-}"
  local shell="${2:-}"
  local strict="${3:-}"
  local startup_dir target shell_name missing_message

  startup_dir="$(startup_path "$shell")" || {
    fail "Unknown shell: $shell"
    return 1
  }

  target="${startup_dir}/${name}"
  shell_name="$(startup__display_name "$shell")" || return 1
  missing_message="${shell_name} startup file not found"
  if [[ -z "$name" ]]; then
    fail "Missing startup name"
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    if [[ -n "$strict" ]]; then
      fail "$missing_message"
      return 1
    fi

    log info "Startup file skipped: $missing_message"
    return 0
  fi

  remove_file "$target" || return 1
  log info "Startup file removed: $target"
}
