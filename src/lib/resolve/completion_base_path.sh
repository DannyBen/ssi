resolve_completion_base_path() {
  local shell="${1:-}"
  local mode="${2:-auto}"
  [[ -n "$shell" ]] || return 1
  mode="$(resolve_completion_mode "$mode")" || return 1

  if [[ "$mode" == "system" ]]; then
    case "$shell" in
      bash)
        printf "%s" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"
        ;;
      zsh)
        printf "%s" "$SSI_SYSTEM_ZSH_COMPLETION_ROOT"
        ;;
      fish)
        printf "%s" "$SSI_SYSTEM_FISH_COMPLETION_ROOT"
        ;;
      *)
        return 1
        ;;
    esac
    return 0
  fi

  case "$shell" in
    bash)
      printf "%s" "$SSI_USER_BASH_COMPLETION_ROOT"
      ;;
    zsh)
      printf "%s" "$SSI_USER_ZSH_COMPLETION_ROOT"
      ;;
    fish)
      printf "%s" "$SSI_USER_FISH_COMPLETION_ROOT"
      ;;
    *)
      return 1
      ;;
  esac
}
