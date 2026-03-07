#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/resolve/startup_paths.sh"
}

@test "resolve_startup_paths returns bash path" {
  export HOME="/home/test"

  run resolve_startup_paths bash

  [ "$status" -eq 0 ]
  [ "$output" = "/home/test/.bashrc.d" ]
}

@test "resolve_startup_paths returns zsh path" {
  export HOME="/home/test"
  export ZDOTDIR="/home/zsh"

  run resolve_startup_paths zsh

  [ "$status" -eq 0 ]
  [ "$output" = "/home/zsh/.zshrc.d" ]
}

@test "resolve_startup_paths returns fish path" {
  export HOME="/home/test"
  export XDG_CONFIG_HOME="/home/test/.config"

  run resolve_startup_paths fish

  [ "$status" -eq 0 ]
  [ "$output" = "/home/test/.config/fish/conf.d" ]
}

@test "resolve_startup_paths returns all paths when requested" {
  export HOME="/home/test"
  export ZDOTDIR="/home/zsh"
  export XDG_CONFIG_HOME="/home/test/.config"

  run resolve_startup_paths all

  [ "$status" -eq 0 ]
  [ "$output" = $'/home/test/.bashrc.d\n/home/zsh/.zshrc.d\n/home/test/.config/fish/conf.d' ]
}
