source_input="${args[source]}"
explicit_name="${args[--name]:-}"
shell="${args[--shell]}"
strict="${args[--strict]:-}"

dry_run_note
startup_install "$source_input" "$explicit_name" "$shell" "$strict"
