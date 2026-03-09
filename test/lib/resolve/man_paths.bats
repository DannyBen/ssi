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

@test "resolve_man_roots returns existing roots in system then user order" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT"
  mkdir -p "$SSI_USER_MAN_ROOT"

  run resolve_man_roots

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}"$'\n'"${SSI_USER_MAN_ROOT}"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}

@test "resolve_man_dirs returns existing man directories in system then user roots" {
  tmp_root="$(mktemp -d)"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system"
  export SSI_USER_MAN_ROOT="$tmp_root/user"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT/man1" "$SSI_SYSTEM_MAN_ROOT/man5"
  mkdir -p "$SSI_USER_MAN_ROOT/man3"
  touch "$SSI_SYSTEM_MAN_ROOT/not-a-dir"

  run resolve_man_dirs

  [ "$status" -eq 0 ]
  expected="${SSI_SYSTEM_MAN_ROOT}/man1"$'\n'"${SSI_SYSTEM_MAN_ROOT}/man5"$'\n'"${SSI_USER_MAN_ROOT}/man3"
  [ "$output" = "$expected" ]

  rm -rf "$tmp_root"
}
