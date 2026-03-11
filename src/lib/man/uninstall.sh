man_uninstall() {
  local name="${1:-}"
  local removed target_info section filename user_dir system_dir user_path
  local system_path target_path

  removed=0
  log info "Uninstalling man page: $name"

  if [[ "$name" != *.* ]]; then
    while IFS= read -r target_path; do
      [[ -n "$target_path" ]] || continue
      man__uninstall_one "$target_path" && removed=1 || return 1
    done < <(man_matches "$name")
  else
    target_info="$(man_target "$name")" || return 1
    section="${target_info%%:*}"
    filename="${target_info#*:}"
    user_dir="$(man_path "$section" user)" || return 1
    system_dir="$(man_path "$section" system)" || return 1
    user_path="${user_dir}/${filename}"
    system_path="${system_dir}/${filename}"

    if [[ -e "$user_path" ]]; then
      man__uninstall_one "$user_path" || return 1
      removed=1
    fi

    if [[ -e "$system_path" ]]; then
      man__uninstall_one "$system_path" || return 1
      removed=1
    fi
  fi

  if [[ "$removed" -eq 0 ]]; then
    log warn "Man page missing: $name"
  fi
}

man__uninstall_one() {
  local target_path="${1:-}"

  if [[ -e "$target_path" ]]; then
    remove_file "$target_path" || return 1
    log info "Man page removed: $target_path"
  fi
}
