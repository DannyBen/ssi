#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/startup/path.sh"
  source "$BASE/startup/paths.sh"
  source "$BASE/startup/test.sh"
}

@test "startup_test reports found for a shell path" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME/.bashrc.d"
  printf "content" > "$HOME/.bashrc.d/tool"
  log() { printf "%s: %s" "$1" "$2"; }

  run startup_test "tool" "bash" ""

  [ "$status" -eq 0 ]
  [ "$output" = "info: Startup file found: $HOME/.bashrc.d/tool" ]

  rm -rf "$tmp_root"
}

@test "startup_test fails when shell path is missing" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  fail() { printf "%s" "$*"; return 1; }

  run startup_test "tool" "bash" ""

  [ "$status" -eq 1 ]
  [[ "$output" == *"Startup file missing: $HOME/.bashrc.d/tool"* ]]

  rm -rf "$tmp_root"
}
