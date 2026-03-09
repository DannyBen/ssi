#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/env/is_command.sh"
  source "$BASE/core/env/is_sudo_usable.sh"
}

@test "is_sudo_usable returns success when sudo command exists and sudo -n true passes" {
  command() {
    if [[ "$1" == "-v" && "$2" == "sudo" ]]; then
      return 0
    fi
    builtin command "$@"
  }
  sudo() { return 0; }

  run is_sudo_usable

  [ "$status" -eq 0 ]
  unset -f command sudo
}

@test "is_sudo_usable returns failure when sudo command is missing" {
  command() {
    if [[ "$1" == "-v" && "$2" == "sudo" ]]; then
      return 1
    fi
    builtin command "$@"
  }

  run is_sudo_usable

  [ "$status" -ne 0 ]
  unset -f command
}

@test "is_sudo_usable returns failure when sudo command exists but sudo -n true fails" {
  command() {
    if [[ "$1" == "-v" && "$2" == "sudo" ]]; then
      return 0
    fi
    builtin command "$@"
  }
  sudo() { return 1; }

  run is_sudo_usable

  [ "$status" -ne 0 ]
  unset -f command sudo
}
