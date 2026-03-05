#!/usr/bin/env bats

@test "resolve_man_base_path returns system man base path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/base_path.sh"
    resolve_man_mode() { printf "system"; }
    resolve_man_base_path
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/share/man" ]
}

@test "resolve_man_base_path returns user man base path from XDG_DATA_HOME fallback" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/base_path.sh"
    resolve_man_mode() { printf "user"; }
    HOME="/tmp/ssi-home"
    XDG_DATA_HOME=""
    resolve_man_base_path
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-home/.local/share/man" ]
}

@test "resolve_man_base_path returns user man base path from XDG_DATA_HOME when set" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/base_path.sh"
    resolve_man_mode() { printf "user"; }
    XDG_DATA_HOME="/tmp/xdg-data"
    resolve_man_base_path
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/xdg-data/man" ]
}

@test "resolve_man_base_path propagates mode resolution error" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/man/base_path.sh"
    resolve_man_mode() { return 1; }
    resolve_man_base_path
  '

  [ "$status" -eq 1 ]
}
