#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/startup/path.sh"
  source "$BASE/startup/paths.sh"
}

@test "startup_path returns bash path" {
  export HOME="/home/test"

  run startup_path bash

  [ "$status" -eq 0 ]
  [ "$output" = "/home/test/.bashrc.d" ]
}

@test "startup_path returns zsh path" {
  export HOME="/home/test"
  export ZDOTDIR="/home/zsh"

  run startup_path zsh

  [ "$status" -eq 0 ]
  [ "$output" = "/home/zsh/.zshrc.d" ]
}

@test "startup_path returns fish path" {
  export HOME="/home/test"
  export XDG_CONFIG_HOME="/home/test/.config"

  run startup_path fish

  [ "$status" -eq 0 ]
  [ "$output" = "/home/test/.config/fish/conf.d" ]
}

@test "startup_paths returns all startup paths" {
  export HOME="/home/test"
  export ZDOTDIR="/home/zsh"
  export XDG_CONFIG_HOME="/home/test/.config"

  run startup_paths

  [ "$status" -eq 0 ]
  [ "$output" = $'/home/test/.bashrc.d\n/home/zsh/.zshrc.d\n/home/test/.config/fish/conf.d' ]
}
