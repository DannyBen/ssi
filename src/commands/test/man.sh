target_name="${args[name]}"
check_all="${args[--all]:-}"

target_info="$(resolve_man_target_from_name "$target_name")" || return 1
section="${target_info%%:*}"
filename="${target_info#*:}"

if [[ -n "$check_all" ]]; then
  found=0
  while IFS= read -r man_dir; do
    [[ -n "$man_dir" ]] || continue
    target_path="${man_dir}/${filename}"
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
  done < <(resolve_man_paths "$section")

  if [[ "$found" -gt 0 ]]; then
    return 0
  fi

  fail "Not found in any path: $filename"
  return 1
fi

mode="$(resolve_man_mode)" || return 1
man_dir="$(resolve_man_path "$section" "$mode")" || return 1
target_path="${man_dir}/${filename}"

if [[ -f "$target_path" ]]; then
  log info "Found: $target_path"
  return 0
fi

fail "Not found: $target_path"
return 1
