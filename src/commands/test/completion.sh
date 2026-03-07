target_name="${args[name]}"
shell="${args[--shell]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" ]]; then
  found=0
  while IFS= read -r completion_root; do
    [[ -n "$completion_root" ]] || continue
    target_path="${completion_root}/${target_name}"
    if [[ -f "$target_path" ]]; then
      if [[ "$found" -eq 0 ]]; then
        log info "Found: $target_path"
      else
        log warn "Duplicate: $target_path"
      fi
      found=$((found + 1))
    else
      log info "Not found: $target_path"
    fi
  done < <(resolve_completion_paths "$shell")

  if [[ "$found" -gt 0 ]]; then
    return 0
  fi

  fail "Not found in any path: $target_name"
  return 1
fi

mode="$(resolve_completion_mode)" || return 1
completion_root="$(resolve_completion_base_path "$shell" "$mode")" || return 1
target_path="${completion_root}/${target_name}"

if [[ -f "$target_path" ]]; then
  log info "Found: $target_path"
  return 0
fi

fail "Not found: $target_path"
return 1
