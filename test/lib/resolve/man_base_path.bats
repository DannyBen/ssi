#!/usr/bin/env bats

setup() {
  export SSI_SYSTEM_MAN_ROOT="/tmp/ssi-system-man"
  export SSI_USER_MAN_ROOT="/tmp/ssi-user-man"
}

@test "resolve_man_base_path returns system man base path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man_base_path.sh"
    resolve_man_mode() { printf "system"; }
    resolve_man_base_path
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-system-man" ]
}

@test "resolve_man_base_path returns user man base path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man_base_path.sh"
    resolve_man_mode() { printf "user"; }
    resolve_man_base_path
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-user-man" ]
}

@test "resolve_man_base_path propagates mode resolution error" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man_base_path.sh"
    resolve_man_mode() { return 1; }
    resolve_man_base_path
  '

  [ "$status" -eq 1 ]
}
