#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/completion/uninstall.sh"
}

@test "completion_uninstall removes user path when present" {
  export SSI_USER_BASH_COMPLETION_ROOT="/tmp/user-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/tmp/system-completions"
  completion_path() {
    if [[ "$2" == "user" ]]; then
      printf "%s" "$SSI_USER_BASH_COMPLETION_ROOT"
    else
      printf "%s" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"
    fi
  }
  remove_file() { return 0; }
  log() { return 0; }
  mkdir -p "$SSI_USER_BASH_COMPLETION_ROOT"
  printf "x" > "$SSI_USER_BASH_COMPLETION_ROOT/tool"

  run completion_uninstall "tool" "bash"

  rm -rf "$SSI_USER_BASH_COMPLETION_ROOT"

  [ "$status" -eq 0 ]
}

@test "completion_uninstall warns when target is missing" {
  completion_path() {
    if [[ "$2" == "user" ]]; then
      printf "/tmp/user-completions"
    else
      printf "/tmp/system-completions"
    fi
  }
  log() { printf "%s %s" "$1" "$2"; }

  run completion_uninstall "missing" "bash"

  [ "$status" -eq 0 ]
  [ "$output" = "info Uninstalling completion: missingwarn Completion missing: missing" ]
}
