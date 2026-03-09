#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/bin/root.sh"
  export SSI_SYSTEM_BIN_ROOT="/tmp/ssi-system-bin"
  export SSI_USER_BIN_ROOT="/tmp/ssi-user-bin"
}

@test "bin_root returns system bin root" {
  bin_mode() { printf "system"; }

  run bin_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-bin" ]
}

@test "bin_root returns user bin root" {
  bin_mode() { printf "user"; }
  HOME="/tmp/ssi-home"

  run bin_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-bin" ]
}

@test "bin_root propagates mode resolution error" {
  bin_mode() { return 1; }

  run bin_root

  [ "$status" -eq 1 ]
}
