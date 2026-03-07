#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_BIN_ROOT="$tmp_root/user-bin"
  export SSI_SYSTEM_BIN_ROOT="/root/ssi-system-bin"
  mkdir -p "$SSI_USER_BIN_ROOT"
  FIXTURES="$BATS_TEST_DIRNAME/../../fixtures"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "install bin installs from url into user bin when sudo is unusable" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install bin "https://example.com/tool"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_BIN_ROOT/tool" ]
  [ -f "$SSI_USER_BIN_ROOT/tool" ]
  [ "$(cat "$SSI_USER_BIN_ROOT/tool")" = "downloaded:https://example.com/tool" ]
}

@test "install bin installs from stdin when explicit name is provided" {
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  run ./ssi install bin - --name stdin-tool <<< "from-stdin"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_BIN_ROOT/stdin-tool" ]
  [ -f "$SSI_USER_BIN_ROOT/stdin-tool" ]
  [ "$(cat "$SSI_USER_BIN_ROOT/stdin-tool")" = "from-stdin" ]
}

@test "install bin fails when target name cannot be determined and no explicit name provided" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install bin "https://example.com/tools/"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Could not determine target name; use --name"* ]]
}
