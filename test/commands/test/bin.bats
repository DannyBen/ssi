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

  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "test bin succeeds when file exists in user bin" {
  printf "#!/usr/bin/env bash\n" > "$SSI_USER_BIN_ROOT/op"
  chmod +x "$SSI_USER_BIN_ROOT/op"

  run ./ssi test bin op

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Found: $SSI_USER_BIN_ROOT/op" ]
}

@test "test bin fails when file does not exist" {
  run ./ssi test bin missing

  [ "$status" -ne 0 ]
  [ "$output" = "• error → Not found: $SSI_USER_BIN_ROOT/missing" ]
}

@test "test bin --all reports all paths and succeeds if any found" {
  export SSI_SYSTEM_BIN_ROOT="$tmp_root/system-bin"
  export SSI_USER_BIN_ROOT="$tmp_root/user-bin"
  mkdir -p "$SSI_SYSTEM_BIN_ROOT" "$SSI_USER_BIN_ROOT"
  printf "#!/usr/bin/env bash\n" > "$SSI_SYSTEM_BIN_ROOT/op"
  chmod +x "$SSI_SYSTEM_BIN_ROOT/op"

  run ./ssi test bin op --all

  [ "$status" -eq 0 ]
  [ "$output" = $'• info → Found: '"$SSI_SYSTEM_BIN_ROOT"$'/op\n• info → Not found: '"$SSI_USER_BIN_ROOT"$'/op' ]
}
