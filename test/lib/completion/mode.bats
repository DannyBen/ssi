#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/env/is_root.sh"
  source "$BASE/core/env/is_writable_dir.sh"
  source "$BASE/core/env/is_sudo_usable.sh"
  source "$BASE/completion/mode.sh"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/tmp/ssi-system-bash-completions"
  completion__bash_root() { printf "%s" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"; }
}

@test "completion_mode returns explicit system mode" {
  run completion_mode system

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "completion_mode returns explicit user mode" {
  run completion_mode user

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}

@test "completion_mode fails on invalid mode" {
  run completion_mode nope

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "completion_mode auto resolves to system when root" {
  is_root() { return 0; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run completion_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "completion_mode auto resolves to system when completion root is writable" {
  is_root() { return 1; }
  is_writable_dir() {
    [[ "$1" == "$SSI_SYSTEM_BASH_COMPLETION_ROOT" ]]
  }
  is_sudo_usable() { return 1; }

  run completion_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "completion_mode auto resolves to system when parent is writable" {
  is_root() { return 1; }
  is_writable_dir() {
    [[ "$1" == "$(dirname "$SSI_SYSTEM_BASH_COMPLETION_ROOT")" ]]
  }
  is_sudo_usable() { return 1; }

  run completion_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "completion_mode auto resolves to system when sudo works" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 0; }

  run completion_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "completion_mode auto resolves to user when sudo is unavailable" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run completion_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}
