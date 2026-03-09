#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/bin/uninstall.sh"
}

@test "bin_uninstall removes user path when present" {
  export SSI_USER_BIN_ROOT="/tmp/user-bin"
  export SSI_SYSTEM_BIN_ROOT="/tmp/system-bin"
  remove_file() { return 0; }
  log() { return 0; }
  mkdir -p "$SSI_USER_BIN_ROOT"
  printf "x" > "$SSI_USER_BIN_ROOT/tool"

  run bin_uninstall "tool"

  rm -rf "$SSI_USER_BIN_ROOT"

  [ "$status" -eq 0 ]
}

@test "bin_uninstall warns when target is missing" {
  export SSI_USER_BIN_ROOT="/tmp/user-bin"
  export SSI_SYSTEM_BIN_ROOT="/tmp/system-bin"
  log() { printf "%s %s" "$1" "$2"; }

  run bin_uninstall "missing"

  [ "$status" -eq 0 ]
  [ "$output" = "warn Not found: missing" ]
}
