#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/bin/test.sh"
}

@test "bin_test reports found in resolved root" {
  bin_mode() { printf "user"; }
  bin_root() { printf "%s" "$TEST_ROOT"; }
  log() { printf "%s: %s" "$1" "$2"; }
  TEST_ROOT="$(mktemp -d)"
  printf "#!/usr/bin/env bash\n" > "$TEST_ROOT/tool"
  chmod +x "$TEST_ROOT/tool"

  run bin_test "tool" ""

  rm -rf "$TEST_ROOT"

  [ "$status" -eq 0 ]
  [ "$output" = "info: Found: $TEST_ROOT/tool" ]
}

@test "bin_test fails when target is missing" {
  bin_mode() { printf "user"; }
  bin_root() { printf "/tmp/missing-root"; }
  fail() { printf "%s" "$*"; return 1; }

  run bin_test "missing" ""

  [ "$status" -eq 1 ]
  [ "$output" = "Not found: /tmp/missing-root/missing" ]
}
