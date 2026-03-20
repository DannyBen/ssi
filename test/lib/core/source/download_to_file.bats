#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/env/is_command.sh"
  source "$BASE/core/source/download.sh"
  source "$BASE/core/source/download_to_file.sh"
}

download_and_cat() {
  local url="$1"
  local out="$2"
  source_download_to_file "$url" "$out" || return 1
  cat "$out"
}

@test "source_download_to_file uses curl when available" {
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

@test "source_download_to_file uses wget when curl is unavailable" {
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

@test "source_download_to_file fails when no downloader is available" {
  is_command() {
    return 1
  }
  run source_download_to_file "https://example.com/c" "/tmp/out"

  [ "$status" -eq 1 ]
  [[ "$output" == *"No downloader available"* ]]
}
