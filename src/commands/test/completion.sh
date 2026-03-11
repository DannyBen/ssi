target_name="${args[name]}"
shell="${args[--shell]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" ]]; then
  log info "$(bold "Checking completion in all paths"): $target_name"
else
  log info "$(bold "Checking completion"): $target_name"
fi
completion_test "$target_name" "$shell" "$check_all"
