completion_test() {
  local target_name="${1:-}"
  local shell="${2:-}"
  local check_all="${3:-}"
  local found mode target_root target_path

  if [[ -n "$check_all" ]]; then
    found=0
    while IFS= read -r target_root; do
      [[ -n "$target_root" ]] || continue
      target_path="${target_root}/${target_name}"
      if [[ -f "$target_path" ]]; then
        if [[ "$found" -eq 0 ]]; then
          log info "Completion found: $target_path"
        else
          log warn "Completion duplicate: $target_path"
        fi
        found=$((found + 1))
      else
        log info "Completion missing: $target_path"
      fi
    done < <(completion_paths "$shell")

    if [[ "$found" -gt 0 ]]; then
      return 0
    fi

    fail "Completion missing in all paths: $target_name"
    return 1
  fi

  mode="$(completion_mode)" || return 1
  target_root="$(completion_path "$shell" "$mode")" || return 1
  target_path="${target_root}/${target_name}"
  if [[ -f "$target_path" ]]; then
    log info "Completion found: $target_path"
    return 0
  fi

  fail "Completion missing: $target_path"
  return 1
}
