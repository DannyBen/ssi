#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/remove_file.sh"
}

@test "remove_file returns success when file is missing" {
  run remove_file "/tmp/ssi-missing-file"

  [ "$status" -eq 0 ]
}

@test "remove_file removes file when writable" {
  file="$(mktemp)"

  run remove_file "$file"

  [ "$status" -eq 0 ]
  [ ! -e "$file" ]
}

@test "remove_file uses sudo when rm fails and sudo is available" {
  is_sudo_usable() { return 0; }
  rm() { return 1; }
  sudo() {
    if [[ "$1" == "rm" ]]; then
      command rm -f "${@:2}"
      return 0
    fi
    return 1
  }

  file="$(mktemp)"

  run remove_file "$file"

  [ "$status" -eq 0 ]
  [ ! -e "$file" ]
}

@test "remove_file fails when rm fails and sudo unavailable" {
  is_sudo_usable() { return 1; }
  rm() { return 1; }

  file="$(mktemp)"

  run remove_file "$file"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
  [ -e "$file" ]
  command rm -f "$file"
}

@test "remove_file fails on missing path" {
  run remove_file ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
