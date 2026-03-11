name="${args[name]}"

dry_run_note
if [[ "$name" == *.* ]]; then
  log info "$(bold "Uninstalling man page"): $name"
else
  log info "$(bold "Uninstalling man pages"): $name"
fi
man_uninstall "$name"
