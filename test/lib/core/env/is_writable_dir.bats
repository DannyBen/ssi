#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/env/is_writable_dir.sh"
}

@test "is_writable_dir returns true for an existing writable directory" {
  local dir
  dir="$(mktemp -d)"
  chmod 755 "$dir"

  run is_writable_dir "$dir"

  [ "$status" -eq 0 ]

  rmdir "$dir"
}

@test "is_writable_dir returns false for an existing non-writable directory" {
  local dir
  dir="$(mktemp -d)"
  chmod 555 "$dir"

  run is_writable_dir "$dir"

  [ "$status" -ne 0 ]

  chmod 755 "$dir"
  rmdir "$dir"
}

@test "is_writable_dir returns false for a missing directory" {
  local dir
  dir="$(mktemp -d)"
  rmdir "$dir"

  run is_writable_dir "$dir"

  [ "$status" -ne 0 ]
}
