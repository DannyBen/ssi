target_name="${args[name]}"
shell="${args[--shell]}"

mode="$(resolve_completion_mode)" || return 1
completion_root="$(resolve_completion_base_path "$shell" "$mode")" || return 1
target_path="${completion_root}/${target_name}"

if [[ -f "$target_path" ]]; then
  log info "Found: $target_path"
  return 0
fi

fail "Not found: $target_path"
return 1
