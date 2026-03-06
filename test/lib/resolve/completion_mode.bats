#!/usr/bin/env bats

@test "resolve_completion_mode returns explicit system mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_mode.sh"
    resolve_completion_mode system
  '

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_completion_mode returns explicit user mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_mode.sh"
    resolve_completion_mode user
  '

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}

@test "resolve_completion_mode fails on invalid mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_mode.sh"
    resolve_completion_mode nope
  '

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "resolve_completion_mode auto resolves to system when sudo works" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_mode.sh"
    sudo() { return 0; }
    resolve_completion_mode auto
  '

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_completion_mode auto resolves to user when sudo is unavailable" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion_mode.sh"
    sudo() { return 1; }
    resolve_completion_mode auto
  '

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}
