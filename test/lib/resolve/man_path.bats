#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/resolve/man_path.sh"
}

@test "resolve_man_path defaults to section 1" {
  resolve_man_base_path() { printf "/tmp/man-root"; }
  run resolve_man_path

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/man-root/man1" ]
}

@test "resolve_man_path appends provided section and mode" {
  resolve_man_base_path() { printf "/tmp/man-root"; }
  run resolve_man_path 7 user

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/man-root/man7" ]
}

@test "resolve_man_path propagates base path resolution error" {
  resolve_man_base_path() { return 1; }
  run resolve_man_path 2 system

  [ "$status" -eq 1 ]
}
