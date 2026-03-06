remove_file() {
  local path="${1:-}"

  if [[ -z "$path" ]]; then
    fail "Missing file"
    return 1
  fi

  if [[ ! -e "$path" ]]; then
    return 0
  fi

  rm -f "$path" 2>/dev/null && return 0

  if is_sudo_usable; then
    sudo rm -f "$path" || {
      fail "Could not remove file: $path"
      return 1
    }
    return 0
  fi

  fail "Could not remove file: $path"
  return 1
}
