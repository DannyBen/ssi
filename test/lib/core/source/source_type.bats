#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/source/source_type.sh"
}

@test "source_type returns stdin for dash" {
  run source_type -

  [ "$status" -eq 0 ]
  [ "$output" = "stdin" ]
}

@test "source_type returns url for http source" {
  run source_type "https://example.com/file"

  [ "$status" -eq 0 ]
  [ "$output" = "url" ]
}

@test "source_type returns file for local file source" {
  local file
  file="$(mktemp)"
  echo "x" > "$file"

  run source_type "$file"

  rm -f "$file"

  [ "$status" -eq 0 ]
  [ "$output" = "file" ]
}

@test "source_type fails for invalid source" {
  run source_type "/definitely/missing/source"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
