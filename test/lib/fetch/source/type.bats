#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../../src/lib/fetch/source/type.sh"
}

@test "fetch_source_type returns stdin for dash" {
  run fetch_source_type -

  [ "$status" -eq 0 ]
  [ "$output" = "stdin" ]
}

@test "fetch_source_type returns url for http source" {
  run fetch_source_type "https://example.com/file"

  [ "$status" -eq 0 ]
  [ "$output" = "url" ]
}

@test "fetch_source_type returns file for local file source" {
  local file
  file="$(mktemp)"
  echo "x" > "$file"

  run fetch_source_type "$file"

  rm -f "$file"

  [ "$status" -eq 0 ]
  [ "$output" = "file" ]
}

@test "fetch_source_type fails for invalid source" {
  run fetch_source_type "/definitely/missing/source"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
