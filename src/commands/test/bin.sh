target_name="${args[name]}"

mode="$(resolve_bin_mode)" || return 1
bin_root="$(resolve_bin_root "$mode")" || return 1
target_path="${bin_root}/${target_name}"

if [[ -x "$target_path" ]]; then
  log info "Found: $target_path"
  return 0
fi

fail "Not found: $target_path"
return 1
