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

startup__missing_message() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s" "Bash startup file not found"
      ;;
    zsh)
      printf "%s" "Zsh startup file not found"
      ;;
    fish)
      printf "%s" "Fish startup file not found"
      ;;
    *)
      return 1
      ;;
  esac
}

startup__warning_title() {
  local shell="${1:-}"

  case "$shell" in
    bash)
      printf "%s" "Bash startup configuration incomplete"
      ;;
    zsh)
      printf "%s" "Zsh startup configuration incomplete"
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
      printf "%s" 'for f in ~/.bashrc.d/*; do . "$f"; done'
      ;;
    zsh)
      printf "%s" 'for f in ~/.zshrc.d/*; do . "$f"; done'
      ;;
    *)
      return 1
      ;;
  esac
}
