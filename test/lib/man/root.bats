#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/man/root.sh"
  export SSI_SYSTEM_MAN_ROOT="/tmp/ssi-system-man"
  export SSI_USER_MAN_ROOT="/tmp/ssi-user-man"
}

@test "man_root returns system man base path" {
  man_mode() { printf "system"; }
  run man_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-man" ]
}

@test "man_root returns user man base path" {
  man_mode() { printf "user"; }
  run man_root

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-man" ]
}

@test "man_root propagates mode resolution error" {
  man_mode() { return 1; }
  run man_root

  [ "$status" -eq 1 ]
}
