#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/resolve/bin_roots.sh"
}

@test "resolve_bin_roots returns system then user roots" {
  export SSI_SYSTEM_BIN_ROOT="/system/bin"
  export SSI_USER_BIN_ROOT="/user/bin"

  run resolve_bin_roots

  [ "$status" -eq 0 ]
  [ "$output" = $'/system/bin\n/user/bin' ]
}
