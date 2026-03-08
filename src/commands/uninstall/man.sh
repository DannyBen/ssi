name="${args[name]}"
remove_all="${args[--all]:-}"
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

if [[ -n "$remove_all" ]]; then
  for base_dir in "$SSI_SYSTEM_MAN_ROOT" "$SSI_USER_MAN_ROOT"; do
    [[ -d "$base_dir" ]] || continue
    for man_dir in "$base_dir"/man*; do
      [[ -d "$man_dir" ]] || continue
      for file in "$man_dir"/"$name".* "$man_dir"/"$name"-*.*; do
        uninstall_man_remove_one "$file" || return 1
      done
    done
  done
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
