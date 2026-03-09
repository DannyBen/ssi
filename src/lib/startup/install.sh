startup_install() {
  local source_input="${1:-}"
  local explicit_name="${2:-}"
  local shell="${3:-}"
  local strict="${4:-}"
  local target_name temp_file rc

  if [[ -n "$explicit_name" ]]; then
    target_name="$explicit_name"
  else
    target_name="$(source_target_name "$source_input")" || return 1
  fi

  if [[ -z "$target_name" ]]; then
    fail "Could not determine target name; use --name"
    return 1
  fi

  temp_file="$(source_to_temp_file "$source_input")" || return 1
  startup__install_one "$temp_file" "$target_name" "$shell" "$strict"
  rc=$?

  if [[ "$temp_file" != "/dev/null" ]]; then
    remove_file "$temp_file" || return 1
  fi

  return "$rc"
}

startup__install_one() {
  local source_input="${1:-}"
  local name="${2:-}"
  local shell="${3:-}"
  local strict="${4:-}"
  local rc_file startup_dir target shell_name missing_message

  rc_file="$(startup__rc_file "$shell")" || {
    fail "Unknown shell: $shell"
    return 1
  }

  startup_dir="$(startup_path "$shell")" || {
    fail "Unknown shell: $shell"
    return 1
  }

  shell_name="$(startup__display_name "$shell")" || return 1
  missing_message="${shell_name} startup file not found"

  if [[ ! -f "$rc_file" && ! -d "$startup_dir" ]]; then
    if [[ -n "$strict" ]]; then
      fail "$missing_message"
      return 1
    fi

    log info "Skip: $missing_message"
    return 0
  fi

  create_dir "$startup_dir" || return 1
  target="${startup_dir}/${name}"
  install_file "$source_input" "$target" 644 || return 1
  log info "Installed startup file: $target"

  if [[ "$shell" == "fish" ]]; then
    return 0
  fi

  if [[ -f "$rc_file" ]] && ! grep -Fq "$(basename "$startup_dir")" "$rc_file"; then
    log warn "${shell_name} startup configuration incomplete; add this to $rc_file:"
    log warn "$(startup__source_hint "$shell")"
  elif [[ ! -f "$rc_file" ]]; then
    log warn "$missing_message; ensure $startup_dir is sourced"
  fi
}
