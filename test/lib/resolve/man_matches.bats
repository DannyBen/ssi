#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/log.sh"
  source "$BASE/resolve/man_paths.sh"
  source "$BASE/resolve/man_matches.sh"
}

@test "resolve_man_matches_in_dir matches base and subcommand pages" {
  tmp_root="$(mktemp -d)"
  man_dir="$tmp_root/man1"
  mkdir -p "$man_dir"
  printf "page" > "$man_dir/rush.1"
  printf "page" > "$man_dir/rush-add.5"
  printf "page" > "$man_dir/rusher.1"

  run resolve_man_matches_in_dir rush "$man_dir"

  [ "$status" -eq 0 ]
  expected="${man_dir}/rush.1"$'\n'"${man_dir}/rush-add.5"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "resolve_man_matches_in_dir strips extension from input" {
  tmp_root="$(mktemp -d)"
  man_dir="$tmp_root/man1"
  mkdir -p "$man_dir"
  printf "page" > "$man_dir/rush.1"
  printf "page" > "$man_dir/rush-add.5"

  run resolve_man_matches_in_dir rush.1 "$man_dir"

  [ "$status" -eq 0 ]
  expected="${man_dir}/rush.1"$'\n'"${man_dir}/rush-add.5"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "resolve_man_matches aggregates matches across system and user roots" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT/man1" "$SSI_USER_MAN_ROOT/man5"
  printf "page" > "$SSI_SYSTEM_MAN_ROOT/man1/rush.1"
  printf "page" > "$SSI_USER_MAN_ROOT/man5/rush-add.5"

  run resolve_man_matches rush

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}/man1/rush.1"$'\n'"${SSI_USER_MAN_ROOT}/man5/rush-add.5"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "resolve_man_matches fails on missing name" {
  run resolve_man_matches ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}

@test "resolve_man_matches_in_dir fails on missing name" {
  run resolve_man_matches_in_dir "" "/tmp"

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}

@test "resolve_man_matches_in_dir fails on missing directory" {
  run resolve_man_matches_in_dir "rush" ""

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}
