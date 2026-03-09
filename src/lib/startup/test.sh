startup_test() {
  local name="${1:-}"
  local shell="${2:-}"
  local check_all="${3:-}"
  local found startup_dir target

  if [[ -n "$check_all" ]]; then
    found=0
    while IFS= read -r startup_dir; do
      [[ -n "$startup_dir" ]] || continue
      target="${startup_dir}/${name}"
      if [[ -f "$target" ]]; then
        if [[ "$found" -eq 0 ]]; then
          log info "Found: $target"
        else
          log warn "Duplicate: $target"
        fi
        found=$((found + 1))
      else
        log info "Not found: $target"
      fi
    done < <(startup_paths)

    if [[ "$found" -gt 0 ]]; then
      return 0
    fi

    fail "Not found in any path: $name"
    return 1
  fi

  startup_dir="$(startup_path "$shell")" || {
    fail "Unknown shell: $shell"
    return 1
  }
  target="${startup_dir}/${name}"

  if [[ -f "$target" ]]; then
    log info "Found: $target"
    return 0
  fi

  fail "Not found: $target"
  return 1
}
