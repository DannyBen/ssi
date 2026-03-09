#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/man/paths.sh"
  source "$BASE/man/matches.sh"
}

@test "man_matches strips extension from input and matches subcommands" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT/man1" "$SSI_USER_MAN_ROOT/man5"
  printf "page" > "$SSI_SYSTEM_MAN_ROOT/man1/rush.1"
  printf "page" > "$SSI_USER_MAN_ROOT/man5/rush-add.5"

  run man_matches rush.1

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}/man1/rush.1"$'\n'"${SSI_USER_MAN_ROOT}/man5/rush-add.5"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "man_matches aggregates matches across system and user roots" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT/man1" "$SSI_USER_MAN_ROOT/man5"
  printf "page" > "$SSI_SYSTEM_MAN_ROOT/man1/rush.1"
  printf "page" > "$SSI_USER_MAN_ROOT/man5/rush-add.5"

  run man_matches rush

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}/man1/rush.1"$'\n'"${SSI_USER_MAN_ROOT}/man5/rush-add.5"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "man_matches fails on missing name" {
  run man_matches ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
