source_input="${args[source]}"
explicit_name="${args[--name]:-}"

mode="$(resolve_bin_mode)" || return 1
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

bin_root="$(resolve_bin_root "$mode")" || return 1
target_path="${bin_root}/${target_name}"

install_file "$temp_file" "$target_path" 755 || return 1

rm -f "$temp_file"
say "Installed" "$target_path"
