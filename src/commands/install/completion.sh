source_input="${args[source]}"
explicit_name="${args[--name]:-}"
shell="${args[--shell]}"

dry_run_note
completion_install "$source_input" "$explicit_name" "$shell"
