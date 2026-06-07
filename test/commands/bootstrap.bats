#!/usr/bin/env bats

@test "bootstrap prints template" {
  run ./ssi bootstrap

  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "bootstrap prints prepared installer without template markers" {
  run ./ssi bootstrap

  [ "$status" -eq 0 ]
  [[ "$output" != *"@PREPARE@"* ]]
  [[ "$output" == *"2>&1"* ]]
  [[ "$output" == *"2>/dev/null"* ]]
  [[ "$output" == *">&2"* ]]
}

@test "bootstrap writes template when FILE is provided" {
  target="$(mktemp)"
  rm -f "$target"

  run ./ssi bootstrap "$target"

  [ "$status" -eq 0 ]
  [ -e "$target" ]
  grep -Fq "prepare_installer() {" "$target"
}
