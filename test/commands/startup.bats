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

@test "startup installs to bashrc.d when shell is bash" {
  printf "source %s\n" "$HOME/.bashrc.d" > "$HOME/.bashrc"

  run ./ssi startup --shell bash - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed startup: tool" ]
  [ -f "$HOME/.bashrc.d/tool" ]
  [ "$(cat "$HOME/.bashrc.d/tool")" = "content" ]
}

@test "startup warns when bashrc.d is not sourced" {
  printf "# bashrc\n" > "$HOME/.bashrc"

  run ./ssi startup --shell bash - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Bash startup configuration incomplete"* ]]
  [[ "$output" == *'for f in ~/.bashrc.d/*; do . "$f"; done'* ]]
  [ -f "$HOME/.bashrc.d/tool" ]
}

@test "startup installs to zshrc.d when shell is zsh" {
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR"
  printf "source %s\n" "$ZDOTDIR/.zshrc.d" > "$ZDOTDIR/.zshrc"

  run ./ssi startup --shell zsh - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed startup: tool" ]
  [ -f "$ZDOTDIR/.zshrc.d/tool" ]
  [ "$(cat "$ZDOTDIR/.zshrc.d/tool")" = "content" ]
}

@test "startup installs to fish conf.d when shell is fish" {
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish"
  printf "# fishrc\n" > "$XDG_CONFIG_HOME/fish/config.fish"

  run ./ssi startup --shell fish - --name tool.fish <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed startup: tool.fish" ]
  [ -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [ "$(cat "$XDG_CONFIG_HOME/fish/conf.d/tool.fish")" = "content" ]
}
