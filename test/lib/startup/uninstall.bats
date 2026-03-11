#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/startup/path.sh"
  source "$BASE/startup/_config.sh"
  source "$BASE/startup/uninstall.sh"
}

@test "startup_uninstall removes a present file" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME/.bashrc.d"
  printf "content" > "$HOME/.bashrc.d/tool"
  remove_file() { command rm -f "$1"; }
  log() { printf "%s" "$2"; }

  run startup_uninstall "tool" "bash" ""

  [ "$status" -eq 0 ]
  [ "$output" = "Uninstalling startup file: $HOME/.bashrc.d/toolStartup file removed: $HOME/.bashrc.d/tool" ]
  [ ! -f "$HOME/.bashrc.d/tool" ]

  rm -rf "$tmp_root"
}

@test "startup_uninstall warns in strict mode when missing" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  fail() { printf "%s" "$*"; return 1; }
  log() { printf "%s" "$2"; }

  run startup_uninstall "tool" "bash" "1"

  [ "$status" -eq 1 ]
  [ "$output" = "Uninstalling startup file: $HOME/.bashrc.d/toolBash startup file not found" ]

  rm -rf "$tmp_root"
}
