#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  FIXTURES="$BATS_TEST_DIRNAME/../fixtures"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "download saves to inferred file name by default" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  chmod +x "$fakebin/curl"

  run ./ssi download "https://example.com/tool.tar.gz"

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Downloading file: tool.tar.gz\n• info  → File downloaded: tool.tar.gz' ]
  [ -f tool.tar.gz ]
  [ "$(cat tool.tar.gz)" = "downloaded:https://example.com/tool.tar.gz" ]
  rm -f tool.tar.gz
}

@test "download writes to stdout when output is dash" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  chmod +x "$fakebin/curl"

  run ./ssi download "https://example.com/tool.tar.gz" -o -

  [ "$status" -eq 0 ]
  [ "$output" = "downloaded:https://example.com/tool.tar.gz" ]
}

@test "download writes to explicit file with wget when curl is unavailable" {
  toolbin="$tmp_root/toolbin"
  mkdir -p "$toolbin"
  cp "$FIXTURES/bin/wget" "$toolbin/wget"
  ln -s /usr/bin/mktemp "$toolbin/mktemp"
  ln -s /bin/rm "$toolbin/rm"
  chmod +x "$toolbin/wget"

  PATH="$toolbin" run /usr/bin/bash ./ssi download "https://example.com/tool.tar.gz" -o fetched.tgz

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Downloading file: fetched.tgz\n• info  → File downloaded: fetched.tgz' ]
  [ "$(cat fetched.tgz)" = "downloaded:https://example.com/tool.tar.gz" ]
  rm -f fetched.tgz
}

@test "download fails when target name cannot be inferred" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  chmod +x "$fakebin/curl"

  run ./ssi download "https://example.com/"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Could not determine output file name; use -o FILE or -o -"* ]]
}
