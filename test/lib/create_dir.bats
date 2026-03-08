#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../src/lib"
  source "$BASE/colors.sh"
  source "$BASE/log.sh"
  source "$BASE/is_sudo_usable.sh"
  source "$BASE/create_dir.sh"
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

@test "create_dir is a no-op in dry run mode" {
  export SSI_DRY_RUN=1
  export SSI_LOG_LEVEL=debug

  dir="$(mktemp -d)"
  rmdir "$dir"

  run create_dir "$dir"

  [ "$status" -eq 0 ]
  [ ! -d "$dir" ]
  [[ "$output" == *"[DRY] Creating directory: $dir"* ]]

  unset -v SSI_DRY_RUN SSI_LOG_LEVEL
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
  unset -f sudo
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
