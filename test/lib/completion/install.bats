#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/completion/install.sh"
}

@test "completion_install installs to resolved root with explicit name" {
  completion_mode() { printf "user"; }
  completion_path() { printf "/tmp/user-completions"; }
  source_to_temp_file() { printf "/tmp/input"; }
  install_file() { return 0; }
  remove_file() { return 0; }
  log() { return 0; }

  run completion_install "-" "tool" "bash"

  [ "$status" -eq 0 ]
}

@test "completion_install fails when target name cannot be determined" {
  completion_mode() { printf "user"; }
  source_target_name() { printf ""; }
  fail() { printf "%s" "$*"; return 1; }

  run completion_install "https://example.com/tools/" "" "bash"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Could not determine target name; use --name"* ]]
}
