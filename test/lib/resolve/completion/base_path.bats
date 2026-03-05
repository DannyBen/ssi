#!/usr/bin/env bats

@test "resolve_completion_base_path returns user bash completion path with HOME fallback" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "user"; }
    HOME="/tmp/ssi-home"
    XDG_DATA_HOME=""
    resolve_completion_base_path bash
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/ssi-home/.local/share/bash-completion/completions" ]
}

@test "resolve_completion_base_path returns user zsh completion path from XDG_DATA_HOME" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "user"; }
    XDG_DATA_HOME="/tmp/xdg-data"
    resolve_completion_base_path zsh
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/xdg-data/zsh/site-functions" ]
}

@test "resolve_completion_base_path returns user fish completion path from XDG_DATA_HOME" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "user"; }
    XDG_DATA_HOME="/tmp/xdg-data"
    resolve_completion_base_path fish
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/xdg-data/fish/vendor_completions.d" ]
}

@test "resolve_completion_base_path returns system zsh path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path zsh
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/share/zsh/site-functions" ]
}

@test "resolve_completion_base_path returns system fish path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path fish
  '

  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/share/fish/vendor_completions.d" ]
}

@test "resolve_completion_base_path returns a valid system bash completion path" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path bash
  '

  [ "$status" -eq 0 ]
  [[ "$output" = "/usr/local/share/bash-completion/completions" || \
     "$output" = "/usr/local/etc/bash_completion.d" || \
     "$output" = "/usr/share/bash-completion/completions" ]]
}

@test "resolve_completion_base_path fails on invalid shell" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { printf "system"; }
    resolve_completion_base_path tcsh
  '

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "resolve_completion_base_path propagates mode resolution error" {
  run bash -lc '
    source "/vagrant/bash/ssi/src/lib/resolve/completion/base_path.sh"
    resolve_completion_mode() { return 1; }
    resolve_completion_base_path bash
  '

  [ "$status" -eq 1 ]
}
