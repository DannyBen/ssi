#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/man/target.sh"
}

@test "man_target defaults to section 1" {
  run man_target tool

  [ "$status" -eq 0 ]
  [ "$output" = "1:tool.1" ]
}

@test "man_target preserves provided section" {
  run man_target tool.5

  [ "$status" -eq 0 ]
  [ "$output" = "5:tool.5" ]
}

@test "man_target uses basename" {
  run man_target "/tmp/docs/tool.7"

  [ "$status" -eq 0 ]
  [ "$output" = "7:tool.7" ]
}

@test "man_target fails on missing name" {
  run man_target ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
