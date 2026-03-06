#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_BIN_ROOT="$tmp_root/user-bin"
  export SSI_SYSTEM_BIN_ROOT="$tmp_root/system-bin"
  mkdir -p "$SSI_USER_BIN_ROOT" "$SSI_SYSTEM_BIN_ROOT"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "uninstall bin removes user bin when present" {
  file="$SSI_USER_BIN_ROOT/tool"
  printf "binary" > "$file"

  run ./ssi uninstall bin tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Removed: $file" ]
  [ ! -e "$file" ]
}

@test "uninstall bin reports not found when missing" {
  run ./ssi uninstall bin missing-tool

  [ "$status" -eq 0 ]
  [ "$output" = "• warn → Not found: missing-tool" ]
}

@test "uninstall bin removes system bin when writable" {
  file="$SSI_SYSTEM_BIN_ROOT/system-tool"
  printf "binary" > "$file"

  run ./ssi uninstall bin system-tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Removed: $file" ]
  [ ! -e "$file" ]
}
