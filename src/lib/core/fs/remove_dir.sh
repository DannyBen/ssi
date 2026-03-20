## Mutator: removes directories from the filesystem.
remove_dir() {
  local path="${1:-}"
  local message

  if [[ -z "$path" ]]; then
    fail "Missing directory"
    return 1
  fi

  if [[ ! -e "$path" ]]; then
    return 0
  fi

  message="Removing directory: $path"
  if [[ -n "${SSI_DRY_RUN:-}" ]]; then
    log debug "[DRY] $message"
    return 0
  fi
  log debug "$message"

  rm -rf "$path" 2>/dev/null && return 0

  if is_sudo_usable; then
    sudo rm -rf "$path" || {
      fail "Could not remove directory: $path"
      return 1
    }
    return 0
  fi

  fail "Could not remove directory: $path"
  return 1
}
