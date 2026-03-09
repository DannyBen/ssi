## Mutator: creates directories on the filesystem.
create_dir() {
  local dir="${1:-}"
  local message

  if [[ -z "$dir" ]]; then
    fail "Missing directory"
    return 1
  fi

  if [[ -d "$dir" ]]; then
    return 0
  fi

  message="Creating directory: $dir"
  if [[ -n "${SSI_DRY_RUN:-}" ]]; then
    log debug "[DRY] $message"
    return 0
  fi
  log debug "$message"

  mkdir -p "$dir" 2>/dev/null && return 0

  if is_sudo_usable; then
    sudo mkdir -p "$dir" || {
      fail "Could not create directory: $dir"
      return 1
    }
    return 0
  fi

  fail "Could not create directory: $dir"
  return 1
}
