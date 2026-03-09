#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/completion/path.sh"
  completion__bash_root() { printf "%s" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"; }
  export SSI_USER_BASH_COMPLETION_ROOT="/tmp/ssi-user-bash-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/tmp/ssi-system-bash-completions"
  export SSI_USER_ZSH_COMPLETION_ROOT="/tmp/ssi-user-zsh-completions"
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="/tmp/ssi-system-zsh-completions"
  export SSI_USER_FISH_COMPLETION_ROOT="/tmp/ssi-user-fish-completions"
  export SSI_SYSTEM_FISH_COMPLETION_ROOT="/tmp/ssi-system-fish-completions"
}

@test "completion_path returns user bash completion path" {
  completion_mode() { printf "user"; }
  run completion_path bash

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-bash-completions" ]
}

@test "completion_path returns user zsh completion path" {
  completion_mode() { printf "user"; }
  run completion_path zsh

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-zsh-completions" ]
}

@test "completion_path returns user fish completion path" {
  completion_mode() { printf "user"; }
  run completion_path fish

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-fish-completions" ]
}

@test "completion_path returns system bash completion path" {
  completion_mode() { printf "system"; }
  run completion_path bash

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-bash-completions" ]
}

@test "completion_path returns system zsh path" {
  completion_mode() { printf "system"; }
  run completion_path zsh

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-zsh-completions" ]
}

@test "completion_path returns system fish path" {
  completion_mode() { printf "system"; }
  run completion_path fish

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-fish-completions" ]
}

@test "completion_path fails on invalid shell" {
  completion_mode() { printf "system"; }
  run completion_path tcsh

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "completion_path propagates mode resolution error" {
  completion_mode() { return 1; }
  run completion_path bash

  [ "$status" -eq 1 ]
}
