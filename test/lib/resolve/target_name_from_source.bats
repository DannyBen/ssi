#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/log.sh"
  source "$BASE/resolve/target_name_from_source.sh"
}

@test "resolve_target_name_from_source returns empty for stdin" {
  run resolve_target_name_from_source -

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "resolve_target_name_from_source returns local basename for file path" {
  run resolve_target_name_from_source "/tmp/tools/rush"

  [ "$status" -eq 0 ]
  [ "$output" = "rush" ]
}

@test "resolve_target_name_from_source returns url basename without query string" {
  run resolve_target_name_from_source "https://example.com/rush?download=1"

  [ "$status" -eq 0 ]
  [ "$output" = "rush" ]
}

@test "resolve_target_name_from_source returns empty for trailing slash url" {
  run resolve_target_name_from_source "https://example.com/tools/"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "resolve_target_name_from_source fails on missing input" {
  run resolve_target_name_from_source ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
