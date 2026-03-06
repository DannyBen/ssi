#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/resolve/bin_root.sh"
}

@test "resolve_bin_root returns system bin root" {
  resolve_bin_mode() { printf "system"; }

  run resolve_bin_root

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin" ]
}

@test "resolve_bin_root returns user bin root" {
  resolve_bin_mode() { printf "user"; }
  HOME="/tmp/ssi-home"

  run resolve_bin_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-home/.local/bin" ]
}

@test "resolve_bin_root propagates mode resolution error" {
  resolve_bin_mode() { return 1; }

  run resolve_bin_root

  [ "$status" -eq 1 ]
}
