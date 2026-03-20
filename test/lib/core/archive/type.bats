#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/source/target_name.sh"
  source "$BASE/core/archive/type.sh"
}

@test "archive_type returns tar.gz for tgz file" {
  run archive_type "/tmp/tool.tgz"

  [ "$status" -eq 0 ]
  [ "$output" = "tar.gz" ]
}

@test "archive_type returns tar.gz for tar.gz url" {
  run archive_type "https://example.com/tool.tar.gz?download=1"

  [ "$status" -eq 0 ]
  [ "$output" = "tar.gz" ]
}

@test "archive_type fails for unsupported archive format" {
  run archive_type "/tmp/tool.zip"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Unsupported archive format"* ]]
}

@test "archive_type fails on missing input" {
  run archive_type ""

  [ "$status" -eq 1 ]
  [[ "$output" == *"Missing archive source"* ]]
}
