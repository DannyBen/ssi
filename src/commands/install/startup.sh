source_input="${args[source]}"
explicit_name="${args[--name]:-}"
shell="${args[--shell]}"
strict="${args[--strict]:-}"

temp_file="$(fetch_source_to_temp_file "$source_input")" || return 1
trap 'rm -f "$temp_file"' RETURN

if [[ -n "$explicit_name" ]]; then
  target_name="$explicit_name"
else
  target_name="$(resolve_target_name_from_source "$source_input")" || return 1
fi

if [[ -z "$target_name" ]]; then
  fail "Could not determine target name; use --name"
  return 1
fi

case "$shell" in
  bash)
    startup_install_bash "$temp_file" "$target_name" "$strict"
    ;;
  zsh)
    startup_install_zsh "$temp_file" "$target_name" "$strict"
    ;;
  fish)
    startup_install_fish "$temp_file" "$target_name" "$strict"
    ;;
  *)
    fail "Unknown shell: $shell"
    return 1
    ;;
esac
