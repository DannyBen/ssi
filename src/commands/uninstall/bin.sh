name="${args[name]}"
user_path="$HOME/.local/bin/$name"
system_path="/usr/local/bin/$name"
removed=0

if [[ -f "$user_path" ]]; then
  remove_file "$user_path" || return 1
  say "Removed" "$user_path"
  removed=1
fi

if [[ -f "$system_path" ]]; then
  remove_file "$system_path" || return 1
  say "Removed" "$system_path"
  removed=1
fi

if [[ "$removed" -eq 0 ]]; then
  warn "Not found" "$name"
fi
