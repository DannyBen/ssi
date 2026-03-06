#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_root.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_writable_dir.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/resolve/man_mode.sh"
  export SSI_SYSTEM_MAN_ROOT="/tmp/ssi-system-man"
}

@test "resolve_man_mode returns explicit system mode" {
  run resolve_man_mode system

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode returns explicit user mode" {
  run resolve_man_mode user

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}

@test "resolve_man_mode fails on invalid mode" {
  run resolve_man_mode nope

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "resolve_man_mode auto resolves to system when root" {
  is_root() { return 0; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run resolve_man_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode auto resolves to system when man root is writable" {
  is_root() { return 1; }
  is_writable_dir() {
    [[ "$1" == "$SSI_SYSTEM_MAN_ROOT" ]]
  }
  is_sudo_usable() { return 1; }

  run resolve_man_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode auto resolves to system when parent is writable" {
  is_root() { return 1; }
  is_writable_dir() {
    [[ "$1" == "$(dirname "$SSI_SYSTEM_MAN_ROOT")" ]]
  }
  is_sudo_usable() { return 1; }

  run resolve_man_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode auto resolves to system when sudo works" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 0; }

  run resolve_man_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode auto resolves to user when sudo is unavailable" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run resolve_man_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}
