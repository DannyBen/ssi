source_input="${args[source]}"
explicit_name="${args[--name]:-}"

install_one() {
  local source="$1"
  local name_override="$2"
  local temp_file target_name target_info section filename man_dir target_path

  if [[ -n "$name_override" ]]; then
    target_name="$name_override"
  else
    target_name="$(resolve_target_name_from_source "$source")" || return 1
  fi

  if [[ -z "$target_name" ]]; then
    fail "Could not determine target name; use --name"
    return 1
  fi

  target_info="$(resolve_man_target_from_name "$target_name")" || return 1
  section="${target_info%%:*}"
  filename="${target_info#*:}"

  man_dir="$(resolve_man_path "$section" "$mode")" || return 1
  target_path="${man_dir}/${filename}"

  if [[ -n "${SSI_DRY_RUN:-}" ]]; then
    log info "[DRY] Installed: $target_path"
    return 0
  fi

  temp_file="$(fetch_source_to_temp_file "$source")" || return 1

  install_file "$temp_file" "$target_path" 644 || return 1

  rm -f "$temp_file"
  log info "Installed: $target_path"
}

mode="$(resolve_man_mode)" || return 1

if [[ -d "$source_input" ]]; then
  if [[ -n "$explicit_name" ]]; then
    fail "--name cannot be used with a directory source"
    return 1
  fi

  matched=0
  for file in "$source_input"/*; do
    [[ -f "$file" ]] || continue
    if [[ "$(basename "$file")" =~ \.([0-9][A-Za-z]{0,3})$ ]]; then
      install_one "$file" "" || return 1
      matched=1
    fi
  done

  if [[ "$matched" -eq 0 ]]; then
    fail "No matching man pages in directory: $source_input"
    return 1
  fi
else
  source_type="$(fetch_source_type "$source_input")" || return 1
  install_one "$source_input" "$explicit_name" || return 1
fi
