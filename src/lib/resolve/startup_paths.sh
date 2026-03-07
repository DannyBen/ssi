resolve_startup_paths() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s\n" "$HOME/.bashrc.d"
      ;;
    zsh)
      printf "%s\n" "${ZDOTDIR:-$HOME}/.zshrc.d"
      ;;
    fish)
      printf "%s\n" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
      ;;
    all)
      printf "%s\n" "$HOME/.bashrc.d"
      printf "%s\n" "${ZDOTDIR:-$HOME}/.zshrc.d"
      printf "%s\n" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
      ;;
    *)
      return 1
      ;;
  esac
}
