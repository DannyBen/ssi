name="${args[name]}"
shell="${args[--shell]}"
status=0

case "$shell" in
  bash)
    if startup_uninstall_bash "$name"; then
      status=0
    else
      status=$?
    fi
    ;;
  zsh)
    if startup_uninstall_zsh "$name"; then
      status=0
    else
      status=$?
    fi
    ;;
  fish)
    if startup_uninstall_fish "$name"; then
      status=0
    else
      status=$?
    fi
    ;;
  *)
    fail "Unknown shell: $shell"
    return 1
    ;;
esac

case "$status" in
  0) ;;
  2) log warn "Not found: $name" ;;
  *) return 1 ;;
esac
