source_input="${args[source]}"
explicit_name="${args[--name]:-}"
shell="${args[--shell]}"
display_name="$explicit_name"

if [[ -z "$display_name" ]]; then
  display_name="$(source_target_name "$source_input" 2>/dev/null || true)"
fi

[[ -n "$display_name" ]] || display_name="$source_input"

dry_run_note
log info "$(bold "Installing completion"): $display_name"
completion_install "$source_input" "$explicit_name" "$shell"
