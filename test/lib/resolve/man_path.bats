#!/usr/bin/env bats

@test "resolve_man_path defaults to section 1" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man_path.sh"
    resolve_man_base_path() { printf "/tmp/man-root"; }
    resolve_man_path
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/man-root/man1" ]
}

@test "resolve_man_path appends provided section and mode" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man_path.sh"
    resolve_man_base_path() { printf "/tmp/man-root"; }
    resolve_man_path 7 user
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/man-root/man7" ]
}

@test "resolve_man_path propagates base path resolution error" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man_path.sh"
    resolve_man_base_path() { return 1; }
    resolve_man_path 2 system
  '

  [ "$status" -eq 1 ]
}
