#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/startup/path.sh"
  source "$BASE/startup/_config.sh"
  source "$BASE/startup/install.sh"
  export NO_COLOR=1
}

@test "startup_install installs for bash and warns when not sourced" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  printf "# bashrc\n" > "$HOME/.bashrc"
  printf "content" > "$tmp_root/source"
  source_to_temp_file() { printf "%s" "$tmp_root/source"; }
  create_dir() { command mkdir -p "$1"; }
  install_file() { command cp "$1" "$2"; }
  remove_file() { return 0; }
  log() { printf "%s\n" "$2"; }

  run startup_install "$tmp_root/source" "tool" "bash" ""

  [ "$status" -eq 0 ]
  [ -f "$HOME/.bashrc.d/tool" ]
  [[ "$output" == *"Installing startup file: $HOME/.bashrc.d/tool"* ]]
  [[ "$output" == *"Startup file installed: $HOME/.bashrc.d/tool"* ]]
  [[ "$output" == *"Bash startup configuration incomplete"* ]]

  rm -rf "$tmp_root"
}

@test "startup_install fails in strict mode when shell startup is missing" {
  tmp_root="$(mktemp -d)"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  source_to_temp_file() { printf "%s" "$tmp_root/source"; }
  remove_file() { return 0; }
  fail() { printf "%s" "$*"; return 1; }
  log() { printf "%s\n" "$2"; }

  run startup_install "-" "tool" "bash" "1"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Bash startup file not found"* ]]

  rm -rf "$tmp_root"
}

@test "startup_install installs for fish without shell warning" {
  tmp_root="$(mktemp -d)"
  export XDG_CONFIG_HOME="$tmp_root/config"
  mkdir -p "$XDG_CONFIG_HOME/fish"
  printf "# fishrc\n" > "$XDG_CONFIG_HOME/fish/config.fish"
  printf "content" > "$tmp_root/source"
  source_to_temp_file() { printf "%s" "$tmp_root/source"; }
  create_dir() { command mkdir -p "$1"; }
  install_file() { command cp "$1" "$2"; }
  remove_file() { return 0; }
  log() { printf "%s\n" "$2"; }

  run startup_install "$tmp_root/source" "tool.fish" "fish" ""

  [ "$status" -eq 0 ]
  [ -f "$XDG_CONFIG_HOME/fish/conf.d/tool.fish" ]
  [[ "$output" == *"Installing startup file: $XDG_CONFIG_HOME/fish/conf.d/tool.fish"* ]]
  [[ "$output" == *"Startup file installed: $XDG_CONFIG_HOME/fish/conf.d/tool.fish"* ]]

  rm -rf "$tmp_root"
}
