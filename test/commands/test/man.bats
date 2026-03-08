#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_MAN_ROOT="$tmp_root/user-man"
  export SSI_SYSTEM_MAN_ROOT="/root/ssi-system-man"
  mkdir -p "$SSI_USER_MAN_ROOT"
  FIXTURES="$BATS_TEST_DIRNAME/../../fixtures"

  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "test man resolves default section when no extension is provided" {
  mkdir -p "$SSI_USER_MAN_ROOT/man1"
  printf "manpage" > "$SSI_USER_MAN_ROOT/man1/op.1"

  run ./ssi test man op

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Found: $SSI_USER_MAN_ROOT/man1/op.1" ]
}

@test "test man uses provided section when extension exists" {
  mkdir -p "$SSI_USER_MAN_ROOT/man7"
  printf "manpage" > "$SSI_USER_MAN_ROOT/man7/op.7"

  run ./ssi test man op.7

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Found: $SSI_USER_MAN_ROOT/man7/op.7" ]
}

@test "test man --all reports all paths and succeeds if any found" {
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system-man"
  export SSI_USER_MAN_ROOT="$tmp_root/user-man"
  mkdir -p "$SSI_SYSTEM_MAN_ROOT/man1" "$SSI_USER_MAN_ROOT/man1"
  printf "manpage" > "$SSI_SYSTEM_MAN_ROOT/man1/op.1"

  run ./ssi test man op --all

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Found: '"$SSI_SYSTEM_MAN_ROOT"$'/man1/op.1\n• info  → Not found: '"$SSI_USER_MAN_ROOT"$'/man1/op.1' ]
}
