resolve_man_paths() {
  local section="${1:-1}"

  printf "%s\n%s\n" \
    "$(resolve_man_path "$section" system)" \
    "$(resolve_man_path "$section" user)"
}

resolve_man_roots() {
  local root

  for root in "$SSI_SYSTEM_MAN_ROOT" "$SSI_USER_MAN_ROOT"; do
    [[ -d "$root" ]] || continue
    printf "%s\n" "$root"
  done
}

resolve_man_dirs() {
  local base_dir man_dir

  while IFS= read -r base_dir; do
    [[ -n "$base_dir" ]] || continue
    for man_dir in "$base_dir"/man*; do
      [[ -d "$man_dir" ]] || continue
      printf "%s\n" "$man_dir"
    done
  done < <(resolve_man_roots)
}
