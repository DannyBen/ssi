#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/man/test.sh"
}

@test "man_test reports found for a sectioned page" {
  man_target() { printf "1:tool.1"; }
  man_mode() { printf "user"; }
  man_path() { printf "%s" "$TEST_ROOT/man1"; }
  log() { printf "%s: %s" "$1" "$2"; }
  TEST_ROOT="$(mktemp -d)"
  mkdir -p "$TEST_ROOT/man1"
  printf "page" > "$TEST_ROOT/man1/tool.1"

  run man_test "tool.1" ""

  rm -rf "$TEST_ROOT"

  [ "$status" -eq 0 ]
  [ "$output" = "info: Found: $TEST_ROOT/man1/tool.1" ]
}

@test "man_test fails when a sectioned page is missing" {
  man_target() { printf "1:missing.1"; }
  man_mode() { printf "user"; }
  man_path() { printf "/tmp/missing-root/man1"; }
  fail() { printf "%s" "$*"; return 1; }

  run man_test "missing.1" ""

  [ "$status" -eq 1 ]
  [ "$output" = "Not found: /tmp/missing-root/man1/missing.1" ]
}
