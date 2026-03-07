#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/log.sh"
  source "$BASE/resolve/bin_root.sh"
  export SSI_SYSTEM_BIN_ROOT="/tmp/ssi-system-bin"
  export SSI_USER_BIN_ROOT="/tmp/ssi-user-bin"
}

@test "resolve_bin_root returns system bin root" {
  resolve_bin_mode() { printf "system"; }

  run resolve_bin_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-bin" ]
}

@test "resolve_bin_root returns user bin root" {
  resolve_bin_mode() { printf "user"; }
  HOME="/tmp/ssi-home"

  run resolve_bin_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-bin" ]
}

@test "resolve_bin_root propagates mode resolution error" {
  resolve_bin_mode() { return 1; }

  run resolve_bin_root

  [ "$status" -eq 1 ]
}
