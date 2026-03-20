#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/env/is_command.sh"
  source "$BASE/core/source/download.sh"
}

@test "source_download uses curl when available" {
  is_command() {
    [[ "$1" == "curl" ]]
  }
  curl() {
    local url="$2"
    local destination="$4"
    printf "curl:%s" "$url" > "$destination"
  }

  out="$(mktemp)"
  run source_download "https://example.com/a" "$out"
  [ "$status" -eq 0 ]
  [ "$(cat "$out")" = "curl:https://example.com/a" ]
  rm -f "$out"
}

@test "source_download streams to stdout when destination is dash" {
  is_command() {
    [[ "$1" == "curl" ]]
  }
  curl() {
    local url="$2"
    printf "curl:%s" "$url"
  }

  run source_download "https://example.com/a" -

  [ "$status" -eq 0 ]
  [ "$output" = "curl:https://example.com/a" ]
}

@test "source_download uses wget when curl is unavailable" {
  is_command() {
    [[ "$1" == "wget" ]]
  }
  wget() {
    local destination="$2"
    local url="$3"
    printf "wget:%s" "$url" > "$destination"
  }

  out="$(mktemp)"
  run source_download "https://example.com/b" "$out"
  [ "$status" -eq 0 ]
  [ "$(cat "$out")" = "wget:https://example.com/b" ]
  rm -f "$out"
}

@test "source_download reports downloader stderr through fail" {
  is_command() {
    [[ "$1" == "curl" ]]
  }
  curl() {
    printf "%s\n" "curl transport error" >&2
    return 22
  }

  run source_download "https://example.com/c" /tmp/out

  [ "$status" -eq 1 ]
  [[ "$output" == *"curl transport error"* ]]
}
