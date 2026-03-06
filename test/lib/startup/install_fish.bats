#!/usr/bin/env bats

setup() {
  source "$BATS_TEST_DIRNAME/../../../src/lib/colors.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/log.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/is_sudo_usable.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/create_dir.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/install_file.sh"
  source "$BATS_TEST_DIRNAME/../../../src/lib/startup/install_fish.sh"
  export NO_COLOR=1
}

@test "startup_install_fish returns 2 when no config.fish or conf.d exists" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME"

  run startup_install_fish "$tmp_root/source" "tool"

  [ "$status" -eq 2 ]
  [ -z "$output" ]

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

  rm -rf "$tmp_root"
}
