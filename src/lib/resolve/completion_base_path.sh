resolve_completion_base_path() {
  local shell="${1:-}"
  local mode="${2:-auto}"
  local data_home

  [[ -n "$shell" ]] || return 1
  mode="$(resolve_completion_mode "$mode")" || return 1

  case "$shell" in
    bash | zsh | fish)
      ;;
    *)
      return 1
      ;;
  esac

  if [[ "$mode" == "system" ]]; then
    case "$shell" in
      bash)
        if [[ -d "/usr/local/share/bash-completion/completions" ]]; then
          printf "/usr/local/share/bash-completion/completions"
        elif [[ -d "/usr/local/etc/bash_completion.d" ]]; then
          printf "/usr/local/etc/bash_completion.d"
        elif [[ -d "/usr/share/bash-completion/completions" ]]; then
          printf "/usr/share/bash-completion/completions"
        else
          printf "/usr/local/share/bash-completion/completions"
        fi
        ;;
      zsh)
        printf "/usr/local/share/zsh/site-functions"
        ;;
      fish)
        printf "/usr/local/share/fish/vendor_completions.d"
        ;;
    esac
    return 0
  fi

  data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  case "$shell" in
    bash)
      printf "%s/bash-completion/completions" "$data_home"
      ;;
    zsh)
      printf "%s/zsh/site-functions" "$data_home"
      ;;
    fish)
      printf "%s/fish/vendor_completions.d" "$data_home"
      ;;
  esac
}
