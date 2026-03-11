bin_test() {
  local target_name="${1:-}"
  local check_all="${2:-}"
  local found mode target_root target_path

  if [[ -n "$check_all" ]]; then
    found=0
    while IFS= read -r target_root; do
      [[ -n "$target_root" ]] || continue
      target_path="${target_root}/${target_name}"
      if [[ -x "$target_path" ]]; then
        if [[ "$found" -eq 0 ]]; then
          log info "Executable found: $target_path"
        else
          log warn "Executable duplicate: $target_path"
        fi
        found=$((found + 1))
      else
        log info "Executable missing: $target_path"
      fi
    done < <(bin_roots)

    if [[ "$found" -gt 0 ]]; then
      return 0
    fi

    fail "Executable missing in all paths: $target_name"
    return 1
  fi

  mode="$(bin_mode)" || return 1
  target_root="$(bin_root "$mode")" || return 1
  target_path="${target_root}/${target_name}"
  if [[ -x "$target_path" ]]; then
    log info "Executable found: $target_path"
    return 0
  fi

  fail "Executable missing: $target_path"
  return 1
}
