target_name="${args[name]}"
shell="${args[--shell]}"
check_all="${args[--all]:-}"

completion_test "$target_name" "$shell" "$check_all"
