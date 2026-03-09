#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/man/path.sh"
}

@test "man_path defaults to section 1" {
  man_root() { printf "/tmp/man-root"; }
  run man_path

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/man-root/man1" ]
}

@test "man_path appends provided section and mode" {
  man_root() { printf "/tmp/man-root"; }
  run man_path 7 user

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/man-root/man7" ]
}

@test "man_path propagates base path resolution error" {
  man_root() { return 1; }
  run man_path 2 system

  [ "$status" -eq 1 ]
}
