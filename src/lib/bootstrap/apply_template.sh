bootstrap_apply_template() {
  local file="$1"
  local template="$2"
  local prepare_section="$3"
  local rc

  if [[ -e "$file" ]]; then
    rc=0
    bootstrap_update_prepare_installer "$file" "$prepare_section" || rc=$?
    if [[ $rc -eq 0 ]]; then
      log info "Updated prepare_installer in $file"
      return 0
    fi

    if [[ $rc -eq 2 ]]; then
      log error "prepare_installer not found in $file"
    else
      log error "Failed updating prepare_installer in $file"
    fi

    return 1
  fi

  printf "%s\n" "$template" >"$file"
  log info "Created bootstrap template to $file"
}
