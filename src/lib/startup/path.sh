startup_path() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s" "$HOME/.bashrc.d"
      ;;
    zsh)
      printf "%s" "${ZDOTDIR:-$HOME}/.zshrc.d"
      ;;
    fish)
      printf "%s" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
      ;;
    *)
      return 1
      ;;
  esac
}
