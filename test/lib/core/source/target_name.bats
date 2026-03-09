#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/source/target_name.sh"
}

@test "source_target_name returns empty for stdin" {
  run source_target_name -

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "source_target_name returns local basename for file path" {
  run source_target_name "/tmp/tools/rush"

  [ "$status" -eq 0 ]
  [ "$output" = "rush" ]
}

@test "source_target_name returns url basename without query string" {
  run source_target_name "https://example.com/rush?download=1"

  [ "$status" -eq 0 ]
  [ "$output" = "rush" ]
}

@test "source_target_name returns empty for trailing slash url" {
  run source_target_name "https://example.com/tools/"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "source_target_name fails on missing input" {
  run source_target_name ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
