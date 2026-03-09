source_input="${args[source]}"
explicit_name="${args[--name]:-}"

dry_run_note
man_install "$source_input" "$explicit_name"
