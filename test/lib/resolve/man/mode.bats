#!/usr/bin/env bats

@test "resolve_man_mode returns explicit system mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/mode.sh"
    resolve_man_mode system
  '

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode returns explicit user mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/mode.sh"
    resolve_man_mode user
  '

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}

@test "resolve_man_mode fails on invalid mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/mode.sh"
    resolve_man_mode nope
  '

  [ "$status" -eq 1 ]
  [[ "$output" == *"invalid mode: nope"* ]]
}

@test "resolve_man_mode auto resolves to system when sudo works" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/mode.sh"
    sudo() { return 0; }
    resolve_man_mode auto
  '

  [ "$status" -eq 0 ]
  [ "$output" = "system" ]
}

@test "resolve_man_mode auto resolves to user when sudo is unavailable" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/mode.sh"
    sudo() { return 1; }
    resolve_man_mode auto
  '

  [ "$status" -eq 0 ]
  [ "$output" = "user" ]
}
