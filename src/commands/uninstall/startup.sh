name="${args[name]}"
shell="${args[--shell]}"
strict="${args[--strict]:-}"

dry_run_note
log info "$(bold "Uninstalling startup file"): $name"
startup_uninstall "$name" "$shell" "$strict"
