source_input="${args[source]}"
explicit_name="${args[--name]:-}"

mode="$(resolve_man_mode)" || return 1
temp_file="$(fetch_source_to_temp_file "$source_input")" || return 1

if [[ -n "$explicit_name" ]]; then
  target_name="$explicit_name"
else
  target_name="$(resolve_target_name_from_source "$source_input")" || return 1
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

install_file "$temp_file" "$target_path" 644 || return 1

rm -f "$temp_file"
log info "Installed: $target_path"
