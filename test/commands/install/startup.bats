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

@test "install startup installs to bashrc.d when shell is bash" {
  printf "source %s\n" "$HOME/.bashrc.d" > "$HOME/.bashrc"

  run ./ssi install startup --shell bash - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed startup file: $HOME/.bashrc.d/tool" ]
  [ -f "$HOME/.bashrc.d/tool" ]
  [ "$(cat "$HOME/.bashrc.d/tool")" = "content" ]
}

@test "install startup warns when bashrc.d is not sourced" {
  printf "# bashrc\n" > "$HOME/.bashrc"

  run ./ssi install startup --shell bash - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Installed startup file: $HOME/.bashrc.d/tool"* ]]
  [[ "$output" == *"Bash startup configuration incomplete"* ]]
  [[ "$output" == *'for f in ~/.bashrc.d/*; do . "$f"; done'* ]]
  [ -f "$HOME/.bashrc.d/tool" ]
}

@test "install startup fails in strict mode when bash startup is missing" {
  run ./ssi install startup --shell bash --strict - --name tool <<< "content"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Bash startup file not found"* ]]
}

@test "install startup installs to zshrc.d when shell is zsh" {
  export ZDOTDIR="$tmp_root/zsh"
  mkdir -p "$ZDOTDIR"
  printf "source %s\n" "$ZDOTDIR/.zshrc.d" > "$ZDOTDIR/.zshrc"

  run ./ssi install startup --shell zsh - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed startup file: $ZDOTDIR/.zshrc.d/tool" ]
  [ -f "$ZDOTDIR/.zshrc.d/tool" ]
  [ "$(cat "$ZDOTDIR/.zshrc.d/tool")" = "content" ]
}

@test "install startup installs to fish conf.d when shell is fish" {
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish"
  printf "# fishrc\n" > "$XDG_CONFIG_HOME/fish/config.fish"

  run ./ssi install startup --shell fish - --name tool.fish <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed startup file: $XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [ -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [ "$(cat "$XDG_CONFIG_HOME/fish/conf.d/tool.fish")" = "content" ]
}

@test "install startup is a no-op in dry run mode" {
  export SSI_DRY_RUN=1
  printf "source %s\n" "$HOME/.bashrc.d" > "$HOME/.bashrc"

  run ./ssi install startup --shell bash - --name tool <<< "content"

  [ "$status" -eq 0 ]
  [ "$output" = $'• warn → Dry-run enabled\n• info → Installed startup file: '"$HOME"'/.bashrc.d/tool' ]
  [ ! -e "$HOME/.bashrc.d/tool" ]

  unset -v SSI_DRY_RUN
}
