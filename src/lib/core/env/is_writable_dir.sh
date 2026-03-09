is_writable_dir() {
  local dir="$1"
  [[ -n "$dir" && -d "$dir" && -w "$dir" ]]
}
