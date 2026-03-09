source_input="${args[source]}"
explicit_name="${args[--name]:-}"

dry_run_note
bin_install "$source_input" "$explicit_name"
