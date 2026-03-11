name="${args[name]}"
shell="${args[--shell]}"
check_all="${args[--all]:-}"

if [[ -n "$check_all" ]]; then
  log info "$(bold "Checking startup file in all paths"): $name"
else
  log info "$(bold "Checking startup file"): $name"
fi
startup_test "$name" "$shell" "$check_all"
