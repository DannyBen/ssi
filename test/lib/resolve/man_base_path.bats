#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/resolve/man_base_path.sh"
  export SSI_SYSTEM_MAN_ROOT="/tmp/ssi-system-man"
  export SSI_USER_MAN_ROOT="/tmp/ssi-user-man"
}

@test "resolve_man_base_path returns system man base path" {
  resolve_man_mode() { printf "system"; }
  run resolve_man_base_path

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-man" ]
}

@test "resolve_man_base_path returns user man base path" {
  resolve_man_mode() { printf "user"; }
  run resolve_man_base_path

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-man" ]
}

@test "resolve_man_base_path propagates mode resolution error" {
  resolve_man_mode() { return 1; }
  run resolve_man_base_path

  [ "$status" -eq 1 ]
}
