#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/colors.sh"
  source "$BASE/log.sh"
  source "$BASE/is_sudo_usable.sh"
  source "$BASE/create_dir.sh"
  source "$BASE/install_file.sh"
  source "$BASE/startup/install_fish.sh"
  export NO_COLOR=1
}

@test "startup_install_fish skips when no config.fish or conf.d exists" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME"

  run startup_install_fish "$tmp_root/source" "tool"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Skip: Fish startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_install_fish fails in strict mode when no config.fish or conf.d exists" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME"

  run startup_install_fish "$tmp_root/source" "tool" "1"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Fish startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_install_fish installs into conf.d when config.fish exists" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish"
  printf "# fishrc\n" > "$XDG_CONFIG_HOME/fish/config.fish"
  printf "content" > "$tmp_root/source"

  run startup_install_fish "$tmp_root/source" "tool.fish"

  [ "$status" -eq 0 ]
  [ -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [[ "$output" == *"Installed startup file: $XDG_CONFIG_HOME/fish/conf.d/tool.fish"* ]]

  rm -rf "$tmp_root"
}
