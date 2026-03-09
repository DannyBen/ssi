name="${args[name]}"
shell="${args[--shell]}"
strict="${args[--strict]:-}"

dry_run_note
startup_uninstall "$name" "$shell" "$strict"
