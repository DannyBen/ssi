bin_install() {
  local source_input="${1:-}"
  local explicit_name="${2:-}"
  local mode target_name temp_file target_root target_path

  mode="$(bin_mode)" || return 1

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
  target_root="$(bin_root "$mode")" || return 1
  target_path="${target_root}/${target_name}"

  install_file "$temp_file" "$target_path" 755 || return 1

  remove_file "$temp_file"
  log info "Executable installed: $target_path"
}
