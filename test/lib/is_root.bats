#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../src/lib/is_root.sh"
}

@test "is_root returns true when root" {
  id() {
    if [[ "$1" == "-u" ]]; then
      printf "0"
      return 0
    fi
    command id "$@"
  }

  run is_root

  [ "$status" -eq 0 ]
}

@test "is_root returns false when not root" {
  id() {
    if [[ "$1" == "-u" ]]; then
      printf "1000"
      return 0
    fi
    command id "$@"
  }

  run is_root

  [ "$status" -eq 1 ]
}
