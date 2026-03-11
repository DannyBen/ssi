target_name="${args[name]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" || "$target_name" != *.* ]]; then
  log info "$(bold "Checking man page in all paths"): $target_name"
else
  log info "$(bold "Checking man page"): $target_name"
fi
man_test "$target_name" "$check_all"
