source_input="${args[source]}"
explicit_name="${args[--name]:-}"
display_name="$explicit_name"
batch_install=""

if [[ -d "$source_input" ]]; then
  display_name="$source_input"
  batch_install=1
elif archive_type "$source_input" >/dev/null 2>&1; then
  display_name="$(source_target_name "$source_input" 2>/dev/null || true)"
  batch_install=1
elif [[ -z "$display_name" ]]; then
  display_name="$(source_target_name "$source_input" 2>/dev/null || true)"
fi

[[ -n "$display_name" ]] || display_name="$source_input"

dry_run_note
if [[ -n "$batch_install" ]]; then
  log info "$(bold "Installing man pages"): $display_name"
else
  log info "$(bold "Installing man page"): $display_name"
fi
man_install "$source_input" "$explicit_name"
