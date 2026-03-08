source_input="${args[source]}"
explicit_name="${args[--name]:-}"
shell="${args[--shell]}"
strict="${args[--strict]:-}"

source_type="$(fetch_source_type "$source_input")" || return 1
installer=""

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
    installer="startup_install_bash"
    startup_dir="$HOME/.bashrc.d"
    ;;
  zsh)
    installer="startup_install_zsh"
    startup_dir="${ZDOTDIR:-$HOME}/.zshrc.d"
    ;;
  fish)
    installer="startup_install_fish"
    startup_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
    ;;
  *)
    fail "Unknown shell: $shell"
    return 1
    ;;
esac

if [[ -n "${SSI_DRY_RUN:-}" ]]; then
  log info "[DRY] Installed startup file: $startup_dir/$target_name"
  return 0
fi

temp_file="$(fetch_source_to_temp_file "$source_input")" || return 1
trap 'rm -f "$temp_file"' RETURN

"$installer" "$temp_file" "$target_name" "$strict"
