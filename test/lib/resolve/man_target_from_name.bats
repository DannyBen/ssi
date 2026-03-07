#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/log.sh"
  source "$BASE/resolve/man_target_from_name.sh"
}

@test "resolve_man_target_from_name defaults to section 1" {
  run resolve_man_target_from_name tool

  [ "$status" -eq 0 ]
  [ "$output" = "1:tool.1" ]
}

@test "resolve_man_target_from_name preserves provided section" {
  run resolve_man_target_from_name tool.5

  [ "$status" -eq 0 ]
  [ "$output" = "5:tool.5" ]
}

@test "resolve_man_target_from_name uses basename" {
  run resolve_man_target_from_name "/tmp/docs/tool.7"

  [ "$status" -eq 0 ]
  [ "$output" = "7:tool.7" ]
}

@test "resolve_man_target_from_name fails on missing name" {
  run resolve_man_target_from_name ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
