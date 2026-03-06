#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/remove_file.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/startup/uninstall_fish.sh"
  export NO_COLOR=1
}

@test "startup_uninstall_fish returns 2 when file is missing" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME"

  run startup_uninstall_fish "tool.fish"

  [ "$status" -eq 2 ]
  [ -z "$output" ]

  rm -rf "$tmp_root"
}

@test "startup_uninstall_fish removes file when present" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish/conf.d"
  printf "content" > "$XDG_CONFIG_HOME/fish/conf.d/tool.fish"

  run startup_uninstall_fish "tool.fish"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Removed: $XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [ ! -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]

  rm -rf "$tmp_root"
}
