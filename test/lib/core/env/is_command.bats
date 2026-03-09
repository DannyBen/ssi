#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/env/is_command.sh"
}

@test "is_command returns true for an existing command" {
  run is_command sh

  [ "$status" -eq 0 ]
}

@test "is_command returns false for a missing command" {
  run is_command "definitely-not-a-real-command-xyz"

  [ "$status" -ne 0 ]
}

@test "is_command returns false when command name is empty" {
  run is_command ""

  [ "$status" -ne 0 ]
}
