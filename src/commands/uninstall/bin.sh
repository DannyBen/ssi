name="${args[name]}"

dry_run_note
log info "$(bold "Uninstalling executable"): $name"
bin_uninstall "$name"
