#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/create_dir.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/install_file.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/startup/install_bash.sh"
  export NO_COLOR=1
}

@test "startup_install_bash returns 2 when no bashrc or bashrc.d exists" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"

  run startup_install_bash "$tmp_root/source" "tool"

  [ "$status" -eq 2 ]
  [ -z "$output" ]

  rm -rf "$tmp_root"
}

@test "startup_install_bash installs and warns when bashrc.d not sourced" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  printf "# bashrc\n" > "$HOME/.bashrc"
  printf "content" > "$tmp_root/source"

  run startup_install_bash "$tmp_root/source" "tool"

  [ "$status" -eq 0 ]
  [ -f "$HOME/.bashrc.d/tool" ]
  [[ "$output" == *"Bash startup configuration incomplete"* ]]
  [[ "$output" == *'for f in ~/.bashrc.d/*; do . "$f"; done'* ]]

  rm -rf "$tmp_root"
}

@test "startup_install_bash installs without warning when bashrc.d is sourced" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  printf "source %s\n" "$HOME/.bashrc.d" > "$HOME/.bashrc"
  printf "content" > "$tmp_root/source"

  run startup_install_bash "$tmp_root/source" "tool"

  [ "$status" -eq 0 ]
  [ -f "$HOME/.bashrc.d/tool" ]
  [ -z "$output" ]

  rm -rf "$tmp_root"
}
