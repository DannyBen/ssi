startup_paths() {
  printf "%s\n" "$HOME/.bashrc.d"
  printf "%s\n" "${ZDOTDIR:-$HOME}/.zshrc.d"
  printf "%s\n" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
}
