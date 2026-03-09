#!/usr/bin/env bats

# This private helper is tested directly because the branch selection for
# system Bash completion roots is difficult to cover completely through the
# public completion API.

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/completion/_bash_root.sh"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/usr/local/share/bash-completion/completions"
  export IS_DIR_MATCH=""
  export IS_COMMAND_BREW=""
  export BREW_PREFIX="/opt/homebrew"
  is_dir() { [[ -n "$1" && ( "$1" == "$IS_DIR_MATCH" || "$1" == "$IS_DIR_MATCH_2" ) ]]; }
  is_command() { [[ "$1" == "brew" && -n "$IS_COMMAND_BREW" ]]; }
  brew() { printf "%s" "$BREW_PREFIX"; }
}

teardown() {
  unset -f brew
}

@test "completion__bash_root prefers /usr/share/bash-completion/completions" {
  IS_DIR_MATCH="/usr/share/bash-completion/completions"
  run completion__bash_root

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/share/bash-completion/completions" ]
}

@test "completion__bash_root honors custom SSI_SYSTEM_BASH_COMPLETION_ROOT" {
  SSI_SYSTEM_BASH_COMPLETION_ROOT="/custom/bash-completions"
  IS_DIR_MATCH="/usr/share/bash-completion/completions"
  run completion__bash_root

  [ "$status" -eq 0 ]
  [ "$output" = "/custom/bash-completions" ]
}

@test "completion__bash_root prefers /usr/local/etc/bash_completion.d when /usr/share is missing" {
  IS_DIR_MATCH="/usr/local/etc/bash_completion.d"
  run completion__bash_root

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/etc/bash_completion.d" ]
}

@test "completion__bash_root prefers Homebrew when available" {
  IS_COMMAND_BREW="1"
  IS_DIR_MATCH="/opt/homebrew/etc/bash_completion.d"
  run completion__bash_root

  [ "$status" -eq 0 ]
  [ "$output" = "/opt/homebrew/etc/bash_completion.d" ]
}

@test "completion__bash_root falls back to SSI_SYSTEM_BASH_COMPLETION_ROOT" {
  run completion__bash_root

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/share/bash-completion/completions" ]
}
