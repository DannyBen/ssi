target_name="${args[name]}"

mode="$(resolve_man_mode)" || return 1
target_info="$(resolve_man_target_from_name "$target_name")" || return 1
section="${target_info%%:*}"
filename="${target_info#*:}"

man_dir="$(resolve_man_path "$section" "$mode")" || return 1
target_path="${man_dir}/${filename}"

if [[ -f "$target_path" ]]; then
  log info "Found: $target_path"
  return 0
fi

fail "Not found: $target_path"
return 1
