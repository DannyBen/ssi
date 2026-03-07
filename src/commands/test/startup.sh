name="${args[name]}"
shell="${args[--shell]}"

case "$shell" in
  bash)
    target="$HOME/.bashrc.d/$name"
    ;;
  zsh)
    target="${ZDOTDIR:-$HOME}/.zshrc.d/$name"
    ;;
  fish)
    target="${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d/$name"
    ;;
  *)
    fail "Unknown shell: $shell"
    return 1
    ;;
esac

if [[ -f "$target" ]]; then
  log info "Found: $target"
  return 0
fi

fail "Not found: $target"
return 1
