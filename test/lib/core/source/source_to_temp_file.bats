#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/source/source_type.sh"
  source "$BASE/core/source/download_to_file.sh"
  source "$BASE/core/source/source_to_temp_file.sh"
  export NO_COLOR=1
}

teardown() {
  unset -v NO_COLOR log_level
}

@test "source_to_temp_file copies local file content" {
  local input
  input="$(mktemp)"
  printf "from-file" > "$input"

  run source_to_temp_file "$input"

  rm -f "$input"

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  [ "$(cat "$output")" = "from-file" ]
  rm -f "$output"
}

@test "source_to_temp_file writes stdin content to temp file" {
  run source_to_temp_file - <<< "from-stdin"

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  [ "$(cat "$output")" = "from-stdin" ]
  rm -f "$output"
}

@test "source_to_temp_file downloads url source" {
  source_download_to_file() {
    local url="$1"
    local destination="$2"
    printf "downloaded:%s" "$url" > "$destination"
  }

  run source_to_temp_file "https://example.com/tool"

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  [ "$(cat "$output")" = "downloaded:https://example.com/tool" ]
  rm -f "$output"
}

@test "source_to_temp_file logs copy action in debug mode for local files" {
  local input
  log_level=debug
  input="$(mktemp)"
  printf "from-file" > "$input"

  run source_to_temp_file "$input"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Copying source file: $input -> "* ]]
  rm -f "$input" "${output##*$'\n'}"
}

@test "source_to_temp_file fails for invalid source" {
  run source_to_temp_file "/definitely/missing/source"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}

@test "source_to_temp_file returns /dev/null for local file in dry run" {
  export SSI_DRY_RUN=1
  input="$(mktemp)"
  printf "from-file" > "$input"

  run source_to_temp_file "$input"

  rm -f "$input"

  [ "$status" -eq 0 ]
  [ "$output" = "/dev/null" ]

  unset -v SSI_DRY_RUN
}

@test "source_to_temp_file fails for missing local file in dry run" {
  export SSI_DRY_RUN=1

  run source_to_temp_file "/definitely/missing/source"

  [ "$status" -eq 1 ]
  [ -n "$output" ]

  unset -v SSI_DRY_RUN
}
