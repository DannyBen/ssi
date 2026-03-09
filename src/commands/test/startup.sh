name="${args[name]}"
shell="${args[--shell]}"
check_all="${args[--all]:-}"
startup_test "$name" "$shell" "$check_all"
