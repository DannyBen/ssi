name="${args[name]}"
shell="${args[--shell]}"
strict="${args[--strict]:-}"

case "$shell" in
  bash)
    startup_uninstall_bash "$name" "$strict"
    ;;
  zsh)
    startup_uninstall_zsh "$name" "$strict"
    ;;
  fish)
    startup_uninstall_fish "$name" "$strict"
    ;;
  *)
    fail "Unknown shell: $shell"
    return 1
    ;;
esac
