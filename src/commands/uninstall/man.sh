name="${args[name]}"
removed=0

dry_run_message

uninstall_man_remove_one() {
  local target_path="$1"

  if [[ -e "$target_path" ]]; then
    remove_file "$target_path" || return 1
    log info "Removed: $target_path"
    removed=1
  fi
}

if [[ "$name" != *.* ]]; then
  while IFS= read -r target_path; do
    [[ -n "$target_path" ]] || continue
    uninstall_man_remove_one "$target_path" || return 1
  done < <(resolve_man_matches "$name")
else
  target_info="$(resolve_man_target_from_name "$name")" || return 1
  section="${target_info%%:*}"
  filename="${target_info#*:}"

  user_dir="$(resolve_man_path "$section" user)" || return 1
  system_dir="$(resolve_man_path "$section" system)" || return 1

  user_path="${user_dir}/${filename}"
  system_path="${system_dir}/${filename}"

uninstall_man_remove_one "$user_path" || return 1
uninstall_man_remove_one "$system_path" || return 1
fi

if [[ "$removed" -eq 0 ]]; then
  log warn "Not found: $name"
fi
