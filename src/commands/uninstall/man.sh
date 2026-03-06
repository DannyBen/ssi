name="${args[name]}"
removed=0

target_info="$(resolve_man_target_from_name "$name")" || return 1
section="${target_info%%:*}"
filename="${target_info#*:}"

user_dir="$(resolve_man_path "$section" user)" || return 1
system_dir="$(resolve_man_path "$section" system)" || return 1

user_path="${user_dir}/${filename}"
system_path="${system_dir}/${filename}"

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
