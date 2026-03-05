#!/usr/bin/env bats

@test "fetch_source_to_temp_file copies local file content" {
  local input
  input="$(mktemp)"
  printf "from-file" > "$input"

  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/log.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/type.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/download/to_file.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/to_temp_file.sh"
    fetch_source_to_temp_file "'"$input"'"
  '

  rm -f "$input"

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  [ "$(cat "$output")" = "from-file" ]
  rm -f "$output"
}

@test "fetch_source_to_temp_file writes stdin content to temp file" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/log.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/type.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/download/to_file.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/to_temp_file.sh"
    fetch_source_to_temp_file -
  ' <<< "from-stdin"

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  [ "$(cat "$output")" = "from-stdin" ]
  rm -f "$output"
}

@test "fetch_source_to_temp_file downloads url source" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/log.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/type.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/download/to_file.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/to_temp_file.sh"
    fetch_download_to_file() {
      local url="$1"
      local destination="$2"
      printf "downloaded:%s" "$url" > "$destination"
    }
    fetch_source_to_temp_file "https://example.com/tool"
  '

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  [ "$(cat "$output")" = "downloaded:https://example.com/tool" ]
  rm -f "$output"
}

@test "fetch_source_to_temp_file fails for invalid source" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/log.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/type.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/download/to_file.sh"
    source "/vagrant/bash/ssi/src/lib/fetch/source/to_temp_file.sh"
    fetch_source_to_temp_file "/definitely/missing/source"
  '

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
