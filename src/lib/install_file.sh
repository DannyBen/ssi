install_file() {
  local source="${1:-}"
  local destination="${2:-}"
  local mode="${3:-755}"
  local destination_dir

  if [[ -z "$source" || -z "$destination" ]]; then
    fail "Missing source or destination for install"
    return 1
  fi

  destination_dir="$(dirname "$destination")"
  create_dir "$destination_dir" || return 1

  install -m "$mode" "$source" "$destination" 2>/dev/null && return 0

  if is_sudo_usable; then
    sudo install -m "$mode" "$source" "$destination" && return 0
  fi

  fail "Could not install file to destination: $destination"
  return 1
}
