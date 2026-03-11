#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_BASH_COMPLETION_ROOT="$tmp_root/user-bash-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/root/ssi-system-bash-completions"
  export SSI_USER_ZSH_COMPLETION_ROOT="$tmp_root/user-zsh-completions"
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="/root/ssi-system-zsh-completions"
  export SSI_USER_FISH_COMPLETION_ROOT="$tmp_root/user-fish-completions"
  export SSI_SYSTEM_FISH_COMPLETION_ROOT="/root/ssi-system-fish-completions"
  mkdir -p "$SSI_USER_BASH_COMPLETION_ROOT"
  mkdir -p "$SSI_USER_ZSH_COMPLETION_ROOT"
  FIXTURES="$BATS_TEST_DIRNAME/../../fixtures"

  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "test completion succeeds for bash when file exists" {
  printf "completion" > "$SSI_USER_BASH_COMPLETION_ROOT/op"

  run ./ssi test completion op --shell bash

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Checking completion: op\n• info  → Completion found: '"$SSI_USER_BASH_COMPLETION_ROOT"'/op' ]
}

@test "test completion fails when file is missing" {
  run ./ssi test completion op --shell zsh

  [ "$status" -ne 0 ]
  [ "$output" = $'• info  → Checking completion: op\n• error → Completion missing: '"$SSI_USER_ZSH_COMPLETION_ROOT"'/op' ]
}

@test "test completion --all reports all paths and succeeds if any found" {
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="$tmp_root/system-zsh"
  export SSI_USER_ZSH_COMPLETION_ROOT="$tmp_root/user-zsh"
  mkdir -p "$SSI_SYSTEM_ZSH_COMPLETION_ROOT" "$SSI_USER_ZSH_COMPLETION_ROOT"
  printf "completion" > "$SSI_SYSTEM_ZSH_COMPLETION_ROOT/op"

  run ./ssi test completion op --shell zsh --all

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Checking completion in all paths: op\n• info  → Completion found: '"$SSI_SYSTEM_ZSH_COMPLETION_ROOT"$'/op\n• info  → Completion missing: '"$SSI_USER_ZSH_COMPLETION_ROOT"'/op' ]
}
