script_version="$version"
prepare_section="$(bootstrap_prepare_installer "$script_version")"
template="$(bootstrap_template "$prepare_section")"
file="${args[FILE]:-}"

if [[ -n "$file" ]]; then
  bootstrap_apply_template "$file" "$template" "$prepare_section" || return 1
else
  printf "%s\n" "$template"
fi
