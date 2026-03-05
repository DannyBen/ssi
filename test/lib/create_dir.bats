#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../src/lib/create_dir.sh"
}

@test "create_dir returns success when directory already exists" {
  dir="$(mktemp -d)"

  run create_dir "$dir"

  [ "$status" -eq 0 ]
  [ -d "$dir" ]
}

@test "create_dir creates directory when writable" {
  dir="$(mktemp -d)"
  rmdir "$dir"

  run create_dir "$dir"

  [ "$status" -eq 0 ]
  [ -d "$dir" ]
}

@test "create_dir uses sudo when mkdir fails and sudo is available" {
  is_sudo_usable() { return 0; }
  mkdir() { return 1; }
  sudo() {
    if [[ "$1" == "mkdir" ]]; then
      command mkdir -p "${@:3}"
      return 0
    fi
    return 1
  }

  dir="$(mktemp -d)"
  rmdir "$dir"

  run create_dir "$dir"

  [ "$status" -eq 0 ]
  [ -d "$dir" ]
}

@test "create_dir fails when mkdir fails and sudo unavailable" {
  is_sudo_usable() { return 1; }
  mkdir() { return 1; }

  dir="$(mktemp -d)"
  rmdir "$dir"

  run create_dir "$dir"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
