is_sudo_usable() {
  is_command sudo && sudo -n true >/dev/null 2>&1
}
