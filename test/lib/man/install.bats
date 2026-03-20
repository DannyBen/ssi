#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/source/target_name.sh"
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

@test "man_install installs directory pages directly without temp copies" {
  docs_dir="$(mktemp -d)"
  mkdir -p "$docs_dir/share/man/man1"
  printf "main" > "$docs_dir/share/man/man1/tool.1"
  man_mode() { printf "user"; }
  man_path() { printf "/tmp/user-man/man1"; }
  man_target() { printf "1:tool.1"; }
  source_to_temp_file() {
    printf "%s" "unexpected"
    return 1
  }
  install_file() {
    printf "%s|%s|%s" "$1" "$2" "$3"
    return 0
  }
  log() { return 0; }

  run man_install "$docs_dir" ""

  rm -rf "$docs_dir"

  [ "$status" -eq 0 ]
  [ "$output" = "$docs_dir/share/man/man1/tool.1|/tmp/user-man/man1/tool.1|644" ]
}

@test "man_install installs archive pages directly without temp copies" {
  man_mode() { printf "user"; }
  archive_type() { printf "tar.gz"; }
  archive_extract_to_temp_dir() { printf "/tmp/extracted"; }
  man__page_files() { printf "/tmp/extracted/share/man/man1/tool.1\n"; }
  man_path() { printf "/tmp/user-man/man1"; }
  man_target() { printf "1:tool.1"; }
  source_to_temp_file() {
    printf "%s" "unexpected"
    return 1
  }
  install_file() {
    printf "%s|%s|%s" "$1" "$2" "$3"
    return 0
  }
  log() { return 0; }
  remove_dir() { return 0; }

  run man_install "/tmp/tool.tgz" ""

  [ "$status" -eq 0 ]
  [ "$output" = "/tmp/extracted/share/man/man1/tool.1|/tmp/user-man/man1/tool.1|644" ]
}

@test "man_install fails when --name is used with a directory source" {
  docs_dir="$(mktemp -d)"
  man_mode() { printf "user"; }
  fail() { printf "%s" "$*"; return 1; }

  run man_install "$docs_dir" "tool"

  rm -rf "$docs_dir"

  [ "$status" -eq 1 ]
  [ "$output" = "--name cannot be used with a directory or archive source" ]
}

@test "man_install fails when --name is used with an archive source" {
  man_mode() { printf "user"; }
  archive_type() { printf "tar.gz"; }
  fail() { printf "%s" "$*"; return 1; }

  run man_install "/tmp/tool.tgz" "tool"

  [ "$status" -eq 1 ]
  [ "$output" = "--name cannot be used with a directory or archive source" ]
}
