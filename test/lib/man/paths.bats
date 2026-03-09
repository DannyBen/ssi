#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/man/root.sh"
  source "$BASE/man/mode.sh"
  source "$BASE/man/path.sh"
  source "$BASE/man/paths.sh"
}

@test "man_paths returns system then user paths" {
  export SSI_SYSTEM_MAN_ROOT="/system/man"
  export SSI_USER_MAN_ROOT="/user/man"

  run man_paths 1

  [ "$status" -eq 0 ]
  [ "$output" = $'/system/man/man1\n/user/man/man1' ]
}
