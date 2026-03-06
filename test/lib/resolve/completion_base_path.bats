#!/usr/bin/env bats

setup() {
  export SSI_USER_BASH_COMPLETION_ROOT="/tmp/ssi-user-bash-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/tmp/ssi-system-bash-completions"
  export SSI_USER_ZSH_COMPLETION_ROOT="/tmp/ssi-user-zsh-completions"
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="/tmp/ssi-system-zsh-completions"
  export SSI_USER_FISH_COMPLETION_ROOT="/tmp/ssi-user-fish-completions"
  export SSI_SYSTEM_FISH_COMPLETION_ROOT="/tmp/ssi-system-fish-completions"
}

@test "resolve_completion_base_path returns user bash completion path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "user"; }
    resolve_completion_base_path bash
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-bash-completions" ]
}

@test "resolve_completion_base_path returns user zsh completion path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "user"; }
    resolve_completion_base_path zsh
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-zsh-completions" ]
}

@test "resolve_completion_base_path returns user fish completion path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "user"; }
    resolve_completion_base_path fish
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-fish-completions" ]
}

@test "resolve_completion_base_path returns system bash completion path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path bash
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-bash-completions" ]
}

@test "resolve_completion_base_path returns system zsh path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path zsh
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-zsh-completions" ]
}

@test "resolve_completion_base_path returns system fish path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path fish
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-fish-completions" ]
}

@test "resolve_completion_base_path fails on invalid shell" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path tcsh
  '

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "resolve_completion_base_path propagates mode resolution error" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_base_path.sh"
    resolve_completion_mode() { return 1; }
    resolve_completion_base_path bash
  '

  [ "$status" -eq 1 ]
}
