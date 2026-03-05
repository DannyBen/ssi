is_sudo_usable() {
  command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1
}
