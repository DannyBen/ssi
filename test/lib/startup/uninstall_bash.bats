#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/colors.sh"
  source "$BASE/log.sh"
  source "$BASE/is_sudo_usable.sh"
  source "$BASE/remove_file.sh"
  source "$BASE/startup/uninstall_bash.sh"
  export NO_COLOR=1
}

@test "startup_uninstall_bash skips when file is missing" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"

  run startup_uninstall_bash "tool"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Skip: Bash startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_uninstall_bash fails in strict mode when file is missing" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"

  run startup_uninstall_bash "tool" "1"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Bash startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_uninstall_bash removes file when present" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME/.bashrc.d"
  printf "content" > "$HOME/.bashrc.d/tool"

  run startup_uninstall_bash "tool"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Removed startup file: $HOME/.bashrc.d/tool" ]
  [ ! -f "$HOME/.bashrc.d/tool" ]

  rm -rf "$tmp_root"
}
