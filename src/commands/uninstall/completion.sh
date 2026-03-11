name="${args[name]}"
shell="${args[--shell]}"

dry_run_note
log info "$(bold "Uninstalling completion"): $name"
completion_uninstall "$name" "$shell"
