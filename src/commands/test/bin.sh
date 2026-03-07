target_name="${args[name]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" ]]; then
  found=0
  while IFS= read -r bin_root; do
    [[ -n "$bin_root" ]] || continue
    target_path="${bin_root}/${target_name}"
    if [[ -x "$target_path" ]]; then
      if [[ "$found" -eq 0 ]]; then
        log info "Found: $target_path"
      else
        log warn "Duplicate: $target_path"
      fi
      found=$((found + 1))
    else
      log info "Not found: $target_path"
    fi
  done < <(resolve_bin_roots)

  if [[ "$found" -gt 0 ]]; then
    return 0
  fi

  fail "Not found in any path: $target_name"
  return 1
fi

mode="$(resolve_bin_mode)" || return 1
bin_root="$(resolve_bin_root "$mode")" || return 1
target_path="${bin_root}/${target_name}"

if [[ -x "$target_path" ]]; then
  log info "Found: $target_path"
  return 0
fi

fail "Not found: $target_path"
return 1
