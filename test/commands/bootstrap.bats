#!/usr/bin/env bats

@test "bootstrap includes downloader fallback" {
  run ./ssi bootstrap

  [ "$status" -eq 0 ]
  echo "$output" | grep -Fq "command -v wget >/dev/null 2>&1"
}
