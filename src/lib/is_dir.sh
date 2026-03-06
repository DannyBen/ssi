is_dir() {
  local dir="${1:-}"
  [[ -n "$dir" && -d "$dir" ]]
}
