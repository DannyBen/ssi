#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/is_command.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/fetch_download_to_file.sh"
}

download_and_cat() {
  local url="$1"
  local out="$2"
  fetch_download_to_file "$url" "$out" || return 1
  cat "$out"
}

@test "fetch_download_to_file uses curl when available" {
  is_command() {
    [[ "$1" == "curl" ]]
  }
  curl() {
    local url="$2"
    local destination="$4"
    printf "curl:%s" "$url" > "$destination"
  }
  out="$(mktemp)"
  run download_and_cat "https://example.com/a" "$out"
  rm -f "$out"

  [ "$status" -eq 0 ]
  [ "$output" = "curl:https://example.com/a" ]
}

@test "fetch_download_to_file uses wget when curl is unavailable" {
  is_command() {
    [[ "$1" == "wget" ]]
  }
  wget() {
    local destination="$2"
    local url="$3"
    printf "wget:%s" "$url" > "$destination"
  }
  out="$(mktemp)"
  run download_and_cat "https://example.com/b" "$out"
  rm -f "$out"

  [ "$status" -eq 0 ]
  [ "$output" = "wget:https://example.com/b" ]
}

@test "fetch_download_to_file fails when no downloader is available" {
  is_command() {
    return 1
  }
  run fetch_download_to_file "https://example.com/c" "/tmp/out"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
