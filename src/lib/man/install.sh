man_install() {
  local source_input="${1:-}"
  local explicit_name="${2:-}"
  local mode archive_dir rc

  mode="$(man_mode)" || return 1

  if [[ -d "$source_input" ]]; then
    if [[ -n "$explicit_name" ]]; then
      fail "--name cannot be used with a directory or archive source"
      return 1
    fi

    man__install_many "$source_input" "$mode" "directory" "$source_input"
    return $?
  fi

  if archive_type "$source_input" >/dev/null 2>&1; then
    if [[ -n "$explicit_name" ]]; then
      fail "--name cannot be used with a directory or archive source"
      return 1
    fi

    archive_dir="$(archive_extract_to_temp_dir "$source_input")" || return 1
    if [[ "$archive_dir" == "/dev/null" ]]; then
      log info "Man pages skipped: dry-run archive URL inspection unavailable"
      return 0
    fi

    man__install_many "$archive_dir" "$mode" "archive" "$source_input"
    rc=$?
    remove_dir "$archive_dir" || return 1
    return "$rc"
  fi

  man__install_one "$source_input" "$explicit_name" "$mode"
}

man__install_many() {
  local source_root="${1:-}"
  local mode="${2:-}"
  local source_kind="${3:-directory}"
  local source_label="${4:-}"
  local matched=0
  local file

  while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    man__install_file "$file" "" "$mode" || return 1
    matched=1
  done < <(man__page_files "$source_root")

  if [[ "$matched" -eq 0 ]]; then
    fail "No matching man pages in ${source_kind}: ${source_label}"
    return 1
  fi

  return 0
}

man__page_files() {
  local source_root="${1:-}"
  local file

  find "$source_root" -type f | sort | while IFS= read -r file; do
    [[ "$(basename "$file")" =~ \.([0-9][A-Za-z]{0,3})$ ]] || continue
    printf "%s\n" "$file"
  done
}

man__install_one() {
  local source_input="${1:-}"
  local explicit_name="${2:-}"
  local mode="${3:-}"
  local temp_file rc target_name

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
  man__install_file "$temp_file" "$target_name" "$mode"
  rc=$?

  if [[ "$temp_file" != "/dev/null" ]]; then
    remove_file "$temp_file" || return 1
  fi

  return "$rc"
}

man__install_file() {
  local source_file="${1:-}"
  local explicit_name="${2:-}"
  local mode="${3:-}"
  local target_name target_info section filename target_dir target_path

  if [[ -n "$explicit_name" ]]; then
    target_name="$explicit_name"
  else
    target_name="$(source_target_name "$source_file")" || return 1
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

  install_file "$source_file" "$target_path" 644 || return 1

  log info "Man page installed: $target_path"
}
