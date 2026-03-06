name="${args[name]}"
shell="${args[--shell]}"
removed=0

user_root="$(resolve_completion_base_path "$shell" user)" || return 1
system_root="$(resolve_completion_base_path "$shell" system)" || return 1

user_path="${user_root}/${name}"
system_path="${system_root}/${name}"

if [[ -e "$user_path" ]]; then
  remove_file "$user_path" || return 1
  log info "Removed: $user_path"
  removed=1
fi

if [[ -e "$system_path" ]]; then
  remove_file "$system_path" || return 1
  log info "Removed: $system_path"
  removed=1
fi

if [[ "$removed" -eq 0 ]]; then
  log warn "Not found: $name"
fi
