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

@test "uninstall startup removes bash entry when present" {
  mkdir -p "$HOME/.bashrc.d"
  printf "content" > "$HOME/.bashrc.d/tool"

  run ./ssi uninstall startup --shell bash tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Removed startup file: $HOME/.bashrc.d/tool" ]
  [ ! -f "$HOME/.bashrc.d/tool" ]
}

@test "uninstall startup skips when bash entry is missing" {
  run ./ssi uninstall startup --shell bash tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Skip: Bash startup file not found" ]
}

@test "uninstall startup fails in strict mode when bash entry is missing" {
  run ./ssi uninstall startup --shell bash --strict tool

  [ "$status" -eq 1 ]
  [[ "$output" == *"Bash startup file not found"* ]]
}

@test "uninstall startup removes zsh entry when present" {
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR/.zshrc.d"
  printf "content" > "$ZDOTDIR/.zshrc.d/tool"

  run ./ssi uninstall startup --shell zsh tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Removed startup file: $ZDOTDIR/.zshrc.d/tool" ]
  [ ! -f "$ZDOTDIR/.zshrc.d/tool" ]
}

@test "uninstall startup removes fish entry when present" {
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish/conf.d"
  printf "content" > "$XDG_CONFIG_HOME/fish/conf.d/tool.fish"

  run ./ssi uninstall startup --shell fish tool.fish

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Removed startup file: $XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [ ! -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
}
