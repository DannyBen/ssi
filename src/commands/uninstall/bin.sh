name="${args[name]}"
user_root="${SSI_USER_BIN_ROOT}"
system_root="${SSI_SYSTEM_BIN_ROOT}"
user_path="$user_root/$name"
system_path="$system_root/$name"
removed=0

dry_run_message

if [[ -f "$user_path" ]]; then
  remove_file "$user_path" || return 1
  log info "Removed: $user_path"
  removed=1
fi

if [[ -f "$system_path" ]]; then
  remove_file "$system_path" || return 1
  log info "Removed: $system_path"
  removed=1
fi

if [[ "$removed" -eq 0 ]]; then
  log warn "Not found: $name"
fi
