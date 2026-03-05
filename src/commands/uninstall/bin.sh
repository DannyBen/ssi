name="${args[name]}"
user_path="$HOME/.local/bin/$name"
system_path="/usr/local/bin/$name"
removed=0

if [[ -f "$user_path" ]]; then
  rm -f "$user_path"
  printf "removed: %s\n" "$user_path"
  removed=1
fi

if [[ -f "$system_path" ]]; then
  if [[ "${EUID:-$(id -u)}" -eq 0 || -w "/usr/local/bin" ]]; then
    rm -f "$system_path"
    printf "removed: %s\n" "$system_path"
    removed=1
  elif command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
    sudo rm -f "$system_path"
    printf "removed: %s\n" "$system_path"
    removed=1
  else
    printf "cannot remove (permission denied): %s\n" "$system_path" >&2
    return 1
  fi
fi

if [[ "$removed" -eq 0 ]]; then
  printf "not found: %s\n" "$name"
fi
