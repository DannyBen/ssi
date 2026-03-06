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
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system-man"
  mkdir -p "$SSI_USER_MAN_ROOT" "$SSI_SYSTEM_MAN_ROOT"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "man installs from url into user man root" {
  cp "$BATS_TEST_DIRNAME/../fixtures/bin/curl" "$fakebin/curl"
  cp "$BATS_TEST_DIRNAME/../fixtures/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi man "https://example.com/tool.1"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_MAN_ROOT/man1/tool.1" ]
  [ -f "$SSI_USER_MAN_ROOT/man1/tool.1" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/tool.1")" = "downloaded:https://example.com/tool.1" ]
}

@test "man installs from stdin when explicit name is provided" {
  cp "$BATS_TEST_DIRNAME/../fixtures/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  run ./ssi man - --name stdin-tool <<< "from-stdin"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_MAN_ROOT/man1/stdin-tool.1" ]
  [ -f "$SSI_USER_MAN_ROOT/man1/stdin-tool.1" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/stdin-tool.1")" = "from-stdin" ]
}

@test "man fails when target name cannot be determined and no explicit name provided" {
  cp "$BATS_TEST_DIRNAME/../fixtures/bin/curl" "$fakebin/curl"
  cp "$BATS_TEST_DIRNAME/../fixtures/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi man "https://example.com/tools/"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Could not determine target name; use --name"* ]]
}
