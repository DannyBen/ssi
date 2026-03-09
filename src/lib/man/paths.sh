man_paths() {
  local section="${1:-1}"

  printf "%s\n%s\n" \
    "$(man_path "$section" system)" \
    "$(man_path "$section" user)"
}

man__roots() {
  local root

  for root in "$SSI_SYSTEM_MAN_ROOT" "$SSI_USER_MAN_ROOT"; do
    [[ -d "$root" ]] || continue
    printf "%s\n" "$root"
  done
}

man__dirs() {
  local base_dir man_dir

  while IFS= read -r base_dir; do
    [[ -n "$base_dir" ]] || continue
    for man_dir in "$base_dir"/man*; do
      [[ -d "$man_dir" ]] || continue
      printf "%s\n" "$man_dir"
    done
  done < <(man__roots)
}
