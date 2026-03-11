man_install() {
  local source_input="${1:-}"
  local explicit_name="${2:-}"
  local mode matched file

  mode="$(man_mode)" || return 1

  if [[ -d "$source_input" ]]; then
    if [[ -n "$explicit_name" ]]; then
      fail "--name cannot be used with a directory source"
      return 1
    fi

    matched=0
    for file in "$source_input"/*; do
      [[ -f "$file" ]] || continue
      if [[ "$(basename "$file")" =~ \.([0-9][A-Za-z]{0,3})$ ]]; then
        man__install_one "$file" "" "$mode" || return 1
        matched=1
      fi
    done

    if [[ "$matched" -eq 0 ]]; then
      fail "No matching man pages in directory: $source_input"
      return 1
    fi

    return 0
  fi

  man__install_one "$source_input" "$explicit_name" "$mode"
}

man__install_one() {
  local source_input="${1:-}"
  local explicit_name="${2:-}"
  local mode="${3:-}"
  local temp_file target_name target_info section filename target_dir
  local target_path

  if [[ -n "$explicit_name" ]]; then
    target_name="$explicit_name"
  else
    target_name="$(source_target_name "$source_input")" || return 1
  fi

  if [[ -z "$target_name" ]]; then
    fail "Could not determine target name; use --name"
    return 1
  fi

  target_info="$(man_target "$target_name")" || return 1
  section="${target_info%%:*}"
  filename="${target_info#*:}"
  target_dir="$(man_path "$section" "$mode")" || return 1
  target_path="${target_dir}/${filename}"
  temp_file="$(source_to_temp_file "$source_input")" || return 1

  install_file "$temp_file" "$target_path" 644 || return 1

  remove_file "$temp_file"
  log info "Man page installed: $target_path"
}
