#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/resolve/man_base_path.sh"
  source "$BASE/resolve/man_mode.sh"
  source "$BASE/resolve/man_path.sh"
  source "$BASE/resolve/man_paths.sh"
}

@test "resolve_man_paths returns system then user paths" {
  export SSI_SYSTEM_MAN_ROOT="/system/man"
  export SSI_USER_MAN_ROOT="/user/man"

  run resolve_man_paths 1

  [ "$status" -eq 0 ]
  [ "$output" = $'/system/man/man1\n/user/man/man1' ]
}
