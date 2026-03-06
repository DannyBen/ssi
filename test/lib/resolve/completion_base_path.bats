#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/resolve/completion_base_path.sh"
  resolve_bash_completion_root() { printf "%s" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"; }
  export SSI_USER_BASH_COMPLETION_ROOT="/tmp/ssi-user-bash-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/tmp/ssi-system-bash-completions"
  export SSI_USER_ZSH_COMPLETION_ROOT="/tmp/ssi-user-zsh-completions"
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="/tmp/ssi-system-zsh-completions"
  export SSI_USER_FISH_COMPLETION_ROOT="/tmp/ssi-user-fish-completions"
  export SSI_SYSTEM_FISH_COMPLETION_ROOT="/tmp/ssi-system-fish-completions"
}

@test "resolve_completion_base_path returns user bash completion path" {
  resolve_completion_mode() { printf "user"; }
  run resolve_completion_base_path bash

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-bash-completions" ]
}

@test "resolve_completion_base_path returns user zsh completion path" {
  resolve_completion_mode() { printf "user"; }
  run resolve_completion_base_path zsh

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-zsh-completions" ]
}

@test "resolve_completion_base_path returns user fish completion path" {
  resolve_completion_mode() { printf "user"; }
  run resolve_completion_base_path fish

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-fish-completions" ]
}

@test "resolve_completion_base_path returns system bash completion path" {
  resolve_completion_mode() { printf "system"; }
  run resolve_completion_base_path bash

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-bash-completions" ]
}

@test "resolve_completion_base_path returns system zsh path" {
  resolve_completion_mode() { printf "system"; }
  run resolve_completion_base_path zsh

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-zsh-completions" ]
}

@test "resolve_completion_base_path returns system fish path" {
  resolve_completion_mode() { printf "system"; }
  run resolve_completion_base_path fish

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-fish-completions" ]
}

@test "resolve_completion_base_path fails on invalid shell" {
  resolve_completion_mode() { printf "system"; }
  run resolve_completion_base_path tcsh

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "resolve_completion_base_path propagates mode resolution error" {
  resolve_completion_mode() { return 1; }
  run resolve_completion_base_path bash

  [ "$status" -eq 1 ]
}
