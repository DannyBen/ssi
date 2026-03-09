#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/man/install.sh"
}

@test "man_install installs a single page with explicit name" {
  man_mode() { printf "user"; }
  man_path() { printf "/tmp/user-man/man1"; }
  source_to_temp_file() { printf "/tmp/input"; }
  install_file() { return 0; }
  remove_file() { return 0; }
  log() { return 0; }
  man_target() { printf "1:tool.1"; }

  run man_install "-" "tool"

  [ "$status" -eq 0 ]
}

@test "man_install fails when --name is used with a directory source" {
  docs_dir="$(mktemp -d)"
  man_mode() { printf "user"; }
  fail() { printf "%s" "$*"; return 1; }

  run man_install "$docs_dir" "tool"

  rm -rf "$docs_dir"

  [ "$status" -eq 1 ]
  [ "$output" = "--name cannot be used with a directory source" ]
}
