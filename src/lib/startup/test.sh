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
          log info "Startup file found: $target"
        else
          log warn "Startup file duplicate: $target"
        fi
        found=$((found + 1))
      else
        log info "Startup file missing: $target"
      fi
    done < <(startup_paths)

    if [[ "$found" -gt 0 ]]; then
      return 0
    fi

    fail "Startup file missing in all paths: $name"
    return 1
  fi

  startup_dir="$(startup_path "$shell")" || {
    fail "Unknown shell: $shell"
    return 1
  }
  target="${startup_dir}/${name}"
  if [[ -f "$target" ]]; then
    log info "Startup file found: $target"
    return 0
  fi

  fail "Startup file missing: $target"
  return 1
}
