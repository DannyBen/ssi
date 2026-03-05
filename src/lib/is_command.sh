is_command() {
  local name="${1:-}"
  [[ -n "$name" ]] && command -v "$name" >/dev/null 2>&1
}
