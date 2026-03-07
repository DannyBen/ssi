#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/colors.sh"
  source "$BASE/log.sh"
  source "$BASE/is_sudo_usable.sh"
  source "$BASE/create_dir.sh"
  source "$BASE/install_file.sh"
  source "$BASE/startup/install_zsh.sh"
  export NO_COLOR=1
}

@test "startup_install_zsh returns 2 when no zshrc or zshrc.d exists" {
  tmp_root="$(mktemp -d)"
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR"

  run startup_install_zsh "$tmp_root/source" "tool"

  [ "$status" -eq 2 ]
  [ -z "$output" ]

  rm -rf "$tmp_root"
}

@test "startup_install_zsh installs and warns when zshrc.d not sourced" {
  tmp_root="$(mktemp -d)"
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR"
  printf "# zshrc\n" > "$ZDOTDIR/.zshrc"
  printf "content" > "$tmp_root/source"

  run startup_install_zsh "$tmp_root/source" "tool"

  [ "$status" -eq 0 ]
  [ -f "$ZDOTDIR/.zshrc.d/tool" ]
  [[ "$output" == *"Zsh startup configuration incomplete"* ]]
  [[ "$output" == *'for f in ~/.zshrc.d/*; do . "$f"; done'* ]]

  rm -rf "$tmp_root"
}

@test "startup_install_zsh installs without warning when zshrc.d is sourced" {
  tmp_root="$(mktemp -d)"
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR"
  printf "source %s\n" "$ZDOTDIR/.zshrc.d" > "$ZDOTDIR/.zshrc"
  printf "content" > "$tmp_root/source"

  run startup_install_zsh "$tmp_root/source" "tool"

  [ "$status" -eq 0 ]
  [ -f "$ZDOTDIR/.zshrc.d/tool" ]
  [ -z "$output" ]

  rm -rf "$tmp_root"
}
