resolve_bash_completion_root() {
  local brew_prefix
  local brew_root

  if is_dir "/usr/share/bash-completion/completions"; then
    printf "%s" "/usr/share/bash-completion/completions"
    return 0
  fi

  if is_dir "/usr/local/etc/bash_completion.d"; then
    printf "%s" "/usr/local/etc/bash_completion.d"
    return 0
  fi

  if is_command brew; then
    brew_prefix="$(brew --prefix 2>/dev/null)"
    brew_root="${brew_prefix}/etc/bash_completion.d"
    if [[ -n "$brew_prefix" ]] && is_dir "$brew_root"; then
      printf "%s" "$brew_root"
      return 0
    fi
  fi

  printf "%s" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"
}
