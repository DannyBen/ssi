target_name="${args[name]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" ]]; then
  log info "$(bold "Checking executable in all paths"): $target_name"
else
  log info "$(bold "Checking executable"): $target_name"
fi
bin_test "$target_name" "$check_all"
