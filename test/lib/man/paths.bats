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

@test "man__roots returns existing roots in system then user order" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT"
  mkdir -p "$SSI_USER_MAN_ROOT"

  run man__roots

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}"$'\n'"${SSI_USER_MAN_ROOT}"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "man__dirs returns existing man directories in system then user roots" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT/man1" "$SSI_SYSTEM_MAN_ROOT/man5"
  mkdir -p "$SSI_USER_MAN_ROOT/man3"
  touch "$SSI_SYSTEM_MAN_ROOT/not-a-dir"

  run man__dirs

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}/man1"$'\n'"${SSI_SYSTEM_MAN_ROOT}/man5"$'\n'"${SSI_USER_MAN_ROOT}/man3"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}
