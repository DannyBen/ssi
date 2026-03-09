startup__rc_file() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s" "$HOME/.bashrc"
      ;;
    zsh)
      printf "%s" "${ZDOTDIR:-$HOME}/.zshrc"
      ;;
    fish)
      printf "%s" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"
      ;;
    *)
      return 1
      ;;
  esac
}

startup__display_name() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s" "Bash"
      ;;
    zsh)
      printf "%s" "Zsh"
      ;;
    fish)
      printf "%s" "Fish"
      ;;
    *)
      return 1
      ;;
  esac
}

startup__source_hint() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s" "for f in ~/.bashrc.d/*; do . \"\$f\"; done"
      ;;
    zsh)
      printf "%s" "for f in ~/.zshrc.d/*; do . \"\$f\"; done"
      ;;
    *)
      return 1
      ;;
  esac
}
