#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/remove_file.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/startup/uninstall_zsh.sh"
  export NO_COLOR=1
}

@test "startup_uninstall_zsh returns 2 when file is missing" {
  tmp_root="$(mktemp -d)"
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR"

  run startup_uninstall_zsh "tool"

  [ "$status" -eq 2 ]
  [ -z "$output" ]

  rm -rf "$tmp_root"
}

@test "startup_uninstall_zsh removes file when present" {
  tmp_root="$(mktemp -d)"
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR/.zshrc.d"
  printf "content" > "$ZDOTDIR/.zshrc.d/tool"

  run startup_uninstall_zsh "tool"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Removed: $ZDOTDIR/.zshrc.d/tool" ]
  [ ! -f "$ZDOTDIR/.zshrc.d/tool" ]

  rm -rf "$tmp_root"
}
