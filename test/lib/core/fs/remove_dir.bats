#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/env/is_sudo_usable.sh"
  source "$BASE/core/fs/remove_dir.sh"
}

@test "remove_dir returns success when directory is missing" {
  run remove_dir "/tmp/ssi-missing-dir"

  [ "$status" -eq 0 ]
}

@test "remove_dir removes directory when writable" {
  dir="$(mktemp -d)"

  run remove_dir "$dir"

  [ "$status" -eq 0 ]
  [ ! -e "$dir" ]
}

@test "remove_dir is a no-op in dry run mode" {
  export SSI_DRY_RUN=1
  export SSI_LOG_LEVEL=debug

  dir="$(mktemp -d)"

  run remove_dir "$dir"

  [ "$status" -eq 0 ]
  [ -d "$dir" ]
  [[ "$output" == *"[DRY] Removing directory: $dir"* ]]

  rm -rf "$dir"
  unset -v SSI_DRY_RUN SSI_LOG_LEVEL
}

@test "remove_dir uses sudo when rm fails and sudo is available" {
  is_sudo_usable() { return 0; }
  rm() { return 1; }
  sudo() {
    if [[ "$1" == "rm" ]]; then
      command rm -rf "${@:3}"
      return 0
    fi
    return 1
  }

  dir="$(mktemp -d)"

  run remove_dir "$dir"

  [ "$status" -eq 0 ]
  [ ! -e "$dir" ]

  unset -f rm sudo
}

@test "remove_dir fails when rm fails and sudo unavailable" {
  is_sudo_usable() { return 1; }
  rm() { return 1; }

  dir="$(mktemp -d)"

  run remove_dir "$dir"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
  [ -d "$dir" ]
  command rm -rf "$dir"

  unset -f rm
}

@test "remove_dir fails on missing path" {
  run remove_dir ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
