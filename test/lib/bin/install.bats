#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/bin/install.sh"
}

@test "bin_install installs to resolved root with explicit name" {
  bin_mode() { printf "user"; }
  bin_root() { printf "/tmp/user-bin"; }
  source_to_temp_file() { printf "/tmp/input"; }
  install_file() { return 0; }
  remove_file() { return 0; }
  log() { return 0; }

  run bin_install "-" "tool"

  [ "$status" -eq 0 ]
}

@test "bin_install fails when target name cannot be determined" {
  bin_mode() { printf "user"; }
  source_target_name() { printf ""; }
  fail() { printf "%s" "$*"; return 1; }

  run bin_install "https://example.com/tools/" ""

  [ "$status" -eq 1 ]
  [[ "$output" == *"Could not determine target name; use --name"* ]]
}
