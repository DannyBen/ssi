#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/colors.sh"
  source "$BASE/log.sh"
  source "$BASE/is_sudo_usable.sh"
  source "$BASE/remove_file.sh"
  source "$BASE/startup/uninstall_fish.sh"
  export NO_COLOR=1
}

@test "startup_uninstall_fish skips when file is missing" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME"

  run startup_uninstall_fish "tool.fish"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Skip: Fish startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_uninstall_fish fails in strict mode when file is missing" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME"

  run startup_uninstall_fish "tool.fish" "1"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Fish startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_uninstall_fish removes file when present" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish/conf.d"
  printf "content" > "$XDG_CONFIG_HOME/fish/conf.d/tool.fish"

  run startup_uninstall_fish "tool.fish"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Removed startup file: $XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [ ! -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]

  rm -rf "$tmp_root"
}
