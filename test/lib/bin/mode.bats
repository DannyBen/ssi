#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/bin/mode.sh"
  export SSI_SYSTEM_BIN_ROOT="/tmp/ssi-system-bin"
}

@test "bin_mode returns explicit system mode" {
  run bin_mode system

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "bin_mode returns explicit user mode" {
  run bin_mode user

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}

@test "bin_mode fails on invalid mode" {
  run bin_mode nope

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}

@test "bin_mode auto resolves to system when root" {
  is_root() { return 0; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "bin_mode auto resolves to system when system bin root is writable" {
  is_root() { return 1; }
  is_writable_dir() {
    [[ "$1" == "$SSI_SYSTEM_BIN_ROOT" ]]
  }
  is_sudo_usable() { return 1; }

  run bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "bin_mode auto resolves to system when sudo works" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 0; }

  run bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "bin_mode auto resolves to user when sudo is unavailable" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}
