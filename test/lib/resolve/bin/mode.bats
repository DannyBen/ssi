#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../../src/lib/resolve/bin/mode.sh"
}

@test "resolve_bin_mode returns explicit system mode" {
  run resolve_bin_mode system

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_bin_mode returns explicit user mode" {
  run resolve_bin_mode user

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}

@test "resolve_bin_mode fails on invalid mode" {
  run resolve_bin_mode nope

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}

@test "resolve_bin_mode auto resolves to system when root" {
  is_root() { return 0; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run resolve_bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_bin_mode auto resolves to system when /usr/local/bin is writable" {
  is_root() { return 1; }
  is_writable_dir() { return 0; }
  is_sudo_usable() { return 1; }

  run resolve_bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_bin_mode auto resolves to system when sudo works" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 0; }

  run resolve_bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_bin_mode auto resolves to user when sudo is unavailable" {
  is_root() { return 1; }
  is_writable_dir() { return 1; }
  is_sudo_usable() { return 1; }

  run resolve_bin_mode auto

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}
