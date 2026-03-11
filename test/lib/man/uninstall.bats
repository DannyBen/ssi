#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/man/uninstall.sh"
}

@test "man_uninstall removes a sectioned page when present" {
  docs_dir="$(mktemp -d)"
  man_target() { printf "1:tool.1"; }
  man_path() {
    if [[ "$2" == "user" ]]; then
      printf "%s/user/man1" "$docs_dir"
    else
      printf "%s/system/man1" "$docs_dir"
    fi
  }
  remove_file() { return 0; }
  log() { return 0; }
  mkdir -p "$docs_dir/user/man1"
  printf "page" > "$docs_dir/user/man1/tool.1"

  run man_uninstall "tool.1"

  rm -rf "$docs_dir"

  [ "$status" -eq 0 ]
}

@test "man_uninstall warns when nothing is found" {
  man_matches() { return 0; }
  log() { printf "%s %s" "$1" "$2"; }

  run man_uninstall "missing"

  [ "$status" -eq 0 ]
  [ "$output" = "info Uninstalling man page: missingwarn Man page missing: missing" ]
}
