man_matches() {
  local raw_name="${1:-}"
  local base name man_dir file
  local nullglob_state

  if [[ -z "$raw_name" ]]; then
    fail "Missing man page name"
    return 1
  fi

  base="$(basename "$raw_name")"
  if [[ "$base" =~ \.([A-Za-z0-9]+)$ ]]; then
    name="${base%.*}"
  else
    name="$base"
  fi

  nullglob_state="$(shopt -p nullglob || true)"
  shopt -s nullglob

  while IFS= read -r man_dir; do
    [[ -n "$man_dir" ]] || continue
    man__matches_in_dir "$raw_name" "$man_dir"
  done < <(man__dirs)

  eval "$nullglob_state"
}

man__matches_in_dir() {
  local raw_name="${1:-}"
  local man_dir="${2:-}"
  local base name file
  local nullglob_state

  if [[ -z "$raw_name" ]]; then
    fail "Missing man page name"
    return 1
  fi

  if [[ -z "$man_dir" ]]; then
    fail "Missing man directory"
    return 1
  fi

  base="$(basename "$raw_name")"
  if [[ "$base" =~ \.([A-Za-z0-9]+)$ ]]; then
    name="${base%.*}"
  else
    name="$base"
  fi

  nullglob_state="$(shopt -p nullglob || true)"
  shopt -s nullglob

  for file in "$man_dir"/"$name".* "$man_dir"/"$name"-*.*; do
    [[ -f "$file" ]] || continue
    printf "%s\n" "$file"
  done

  eval "$nullglob_state"
}
