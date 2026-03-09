#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/completion/test.sh"
}

@test "completion_test reports found in resolved root" {
  completion_mode() { printf "user"; }
  completion_path() { printf "%s" "$TEST_ROOT"; }
  log() { printf "%s: %s" "$1" "$2"; }
  TEST_ROOT="$(mktemp -d)"
  printf "completion\n" > "$TEST_ROOT/tool"

  run completion_test "tool" "bash" ""

  rm -rf "$TEST_ROOT"

  [ "$status" -eq 0 ]
  [ "$output" = "info: Found: $TEST_ROOT/tool" ]
}

@test "completion_test fails when target is missing" {
  completion_mode() { printf "user"; }
  completion_path() { printf "/tmp/missing-root"; }
  fail() { printf "%s" "$*"; return 1; }

  run completion_test "missing" "bash" ""

  [ "$status" -eq 1 ]
  [ "$output" = "Not found: /tmp/missing-root/missing" ]
}
