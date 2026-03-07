name="${args[name]}"
shell="${args[--shell]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" ]]; then
  found=0
  while IFS= read -r startup_root; do
    [[ -n "$startup_root" ]] || continue
    target="${startup_root}/${name}"
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
  done < <(resolve_startup_paths all)

  if [[ "$found" -gt 0 ]]; then
    return 0
  fi

  fail "Not found in any path: $name"
  return 1
fi

case "$shell" in
  bash|zsh|fish)
    startup_root="$(resolve_startup_paths "$shell")" || return 1
    target="${startup_root}/${name}"
    ;;
  *)
    fail "Unknown shell: $shell"
    return 1
    ;;
esac

if [[ -f "$target" ]]; then
  log info "Found: $target"
  return 0
fi

fail "Not found: $target"
return 1
