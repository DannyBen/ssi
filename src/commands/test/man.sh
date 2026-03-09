target_name="${args[name]}"
check_all="${args[--all]:-}"

target_info="$(resolve_man_target_from_name "$target_name")" || return 1
section="${target_info%%:*}"
filename="${target_info#*:}"

if [[ "$target_name" != *.* ]]; then
  found=0
  while IFS= read -r base_dir; do
    [[ -n "$base_dir" ]] || continue
    has_dirs=0
    for man_dir in "$base_dir"/man*; do
      [[ -d "$man_dir" ]] || continue
      has_dirs=1
      matched=0
      while IFS= read -r target_path; do
        [[ -n "$target_path" ]] || continue
        log info "Found: $target_path"
        matched=1
        found=$((found + 1))
      done < <(resolve_man_matches_in_dir "$target_name" "$man_dir")

      if [[ "$matched" -eq 0 ]]; then
        log info "Not found in: $man_dir"
      fi
    done

    if [[ "$has_dirs" -eq 0 ]]; then
      log info "Not found in: ${base_dir}/man*"
    fi
  done < <(resolve_man_roots)

  if [[ "$found" -gt 0 ]]; then
    return 0
  fi

  fail "Not found in any man path: $target_name"
  return 1
fi

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
