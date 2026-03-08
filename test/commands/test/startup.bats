#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export NO_COLOR=1
}

teardown() {
  rm -rf "$tmp_root"
}

@test "test startup succeeds for bash when file exists" {
  mkdir -p "$HOME/.bashrc.d"
  printf "startup" > "$HOME/.bashrc.d/op"

  run ./ssi test startup op --shell bash

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Found: $HOME/.bashrc.d/op" ]
}

@test "test startup succeeds for zsh when file exists" {
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR/.zshrc.d"
  printf "startup" > "$ZDOTDIR/.zshrc.d/op"

  run ./ssi test startup op --shell zsh

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Found: $ZDOTDIR/.zshrc.d/op" ]
}

@test "test startup fails when file is missing" {
  export XDG_CONFIG_HOME="$tmp_root/config"

  run ./ssi test startup op --shell fish

  [ "$status" -ne 0 ]
  [ "$output" = "• error → Not found: $XDG_CONFIG_HOME/fish/conf.d/op" ]
}

@test "test startup --all checks all shells" {
  export ZDOTDIR="$tmp_root/zsh"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$HOME/.bashrc.d"
  mkdir -p "$ZDOTDIR/.zshrc.d"
  printf "startup" > "$ZDOTDIR/.zshrc.d/op"

  run ./ssi test startup op --all

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Not found: '"$HOME"$'/.bashrc.d/op\n• info  → Found: '"$ZDOTDIR"$'/.zshrc.d/op\n• info  → Not found: '"$XDG_CONFIG_HOME"$'/fish/conf.d/op' ]
}
