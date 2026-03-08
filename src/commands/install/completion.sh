source_input="${args[source]}"
explicit_name="${args[--name]:-}"
shell="${args[--shell]}"

mode="$(resolve_completion_mode)" || return 1
source_type="$(fetch_source_type "$source_input")" || return 1

if [[ -n "$explicit_name" ]]; then
  target_name="$explicit_name"
else
  target_name="$(resolve_target_name_from_source "$source_input")" || return 1
fi

if [[ -z "$target_name" ]]; then
  fail "Could not determine target name; use --name"
  return 1
fi

completion_root="$(resolve_completion_base_path "$shell" "$mode")" || return 1
target_path="${completion_root}/${target_name}"

if [[ -n "${SSI_DRY_RUN:-}" ]]; then
  log info "[DRY] Installed: $target_path"
  return 0
fi

temp_file="$(fetch_source_to_temp_file "$source_input")" || return 1

install_file "$temp_file" "$target_path" 644 || return 1

rm -f "$temp_file"
log info "Installed: $target_path"
